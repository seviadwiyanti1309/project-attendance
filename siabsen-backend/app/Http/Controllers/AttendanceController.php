<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;

class AttendanceController extends Controller
{
    public function checkIn(Request $request)
    {
        $request->validate([
            'photo' => 'required|image|max:5120',
        ]);

        $user = $request->user();
        $today = Carbon::today()->toDateString();

        $existing = Attendance::where('user_id', $user->id)->where('date', $today)->first();
        if ($existing) {
            return response()->json(['message' => 'Sudah check-in hari ini'], 400);
        }

        $now = Carbon::now();
        $standardCheckIn = Carbon::parse($user->standard_check_in);
        $status = $now->format('H:i:s') > $standardCheckIn->format('H:i:s') ? 'telat' : 'tepat_waktu';

        $photoPath = $request->file('photo')->store('selfies', 'public');

        $attendance = Attendance::create([
            'user_id' => $user->id,
            'date' => $today,
            'check_in_time' => $now->format('H:i:s'),
            'check_in_photo' => $photoPath,
            'status' => $status,
        ]);

        return response()->json(['message' => 'Check-in berhasil', 'data' => $attendance]);
    }

    public function checkOut(Request $request)
    {
        $request->validate([
            'photo' => 'required|image|max:5120',
        ]);

        $user = $request->user();
        $today = Carbon::today()->toDateString();

        $attendance = Attendance::where('user_id', $user->id)->where('date', $today)->first();
        if (!$attendance) {
            return response()->json(['message' => 'Belum check-in hari ini'], 400);
        }

        $now = Carbon::now();
        $standardCheckOut = Carbon::parse($user->standard_check_out);
        $overtimeMinutes = 0;

        if ($now->format('H:i:s') > $standardCheckOut->format('H:i:s')) {
            $overtimeMinutes = $now->diffInMinutes($standardCheckOut);
        }

        $photoPath = $request->file('photo')->store('selfies', 'public');

        $attendance->update([
            'check_out_time' => $now->format('H:i:s'),
            'check_out_photo' => $photoPath,
            'overtime_minutes' => $overtimeMinutes,
        ]);

        return response()->json(['message' => 'Check-out berhasil', 'data' => $attendance]);
    }

    public function history(Request $request)
    {
        $attendances = Attendance::where('user_id', $request->user()->id)
            ->orderBy('date', 'desc')
            ->get();

        return response()->json($attendances);
    }

    public function dashboardSummary(Request $request)
    {
        $today = Carbon::today()->toDateString();

        $totalKaryawan = \App\Models\User::where('role', 'karyawan')->count();
        $hadirHariIni = Attendance::where('date', $today)->count();
        $telatHariIni = Attendance::where('date', $today)->where('status', 'telat')->count();

        return response()->json([
            'total_karyawan' => $totalKaryawan,
            'hadir_hari_ini' => $hadirHariIni,
            'belum_hadir' => $totalKaryawan - $hadirHariIni,
            'telat_hari_ini' => $telatHariIni,
        ]);
    }

    public function allAttendances(Request $request)
    {
        $attendances = Attendance::with('user:id,name,position')
            ->orderBy('date', 'desc')
            ->get();

        return response()->json($attendances);
    }

    public function monthlyRecap(Request $request)
    {
        $month = $request->query('month', now()->month);
        $year = $request->query('year', now()->year);

        $employees = \App\Models\User::where('role', 'karyawan')->get();

        $recap = $employees->map(function ($employee) use ($month, $year) {
            $attendances = Attendance::where('user_id', $employee->id)
                ->whereMonth('date', $month)
                ->whereYear('date', $year)
                ->get();

            $totalHadir = $attendances->count();
            $totalTelat = $attendances->where('status', 'telat')->count();

            $approvedOvertimes = \App\Models\OvertimeRequest::where('user_id', $employee->id)
                ->where('status', 'approved')
                ->whereMonth('date', $month)
                ->whereYear('date', $year)
                ->get();

            $hourlyRate = ($employee->base_salary + $employee->tunjangan_tetap) / 173;
            $totalOvertimeMinutes = 0;
            $totalOvertimePay = 0;

            foreach ($approvedOvertimes as $overtime) {
                $totalOvertimeMinutes += $overtime->duration_minutes;
                $hours = $overtime->duration_minutes / 60;
                $isWeekend = \Carbon\Carbon::parse($overtime->date)->isWeekend();
                $totalOvertimePay += $this->calculateOvertimePay($hours, $isWeekend, $hourlyRate);
            }

            return [
                'employee_id' => $employee->id,
                'name' => $employee->name,
                'total_hadir' => $totalHadir,
                'total_telat' => $totalTelat,
                'total_overtime_minutes' => $totalOvertimeMinutes,
                'base_salary' => $employee->base_salary,
                'estimated_overtime_pay' => round($totalOvertimePay, 2),
                'estimated_total_salary' => round($employee->base_salary + $totalOvertimePay, 2),
            ];
        });

        return response()->json($recap);
    }

    private function calculateOvertimePay($hours, $isWeekend, $hourlyRate)
    {
        $pay = 0;
        $remaining = $hours;

        if ($isWeekend) {
            // Jam 1-8: 2x
            $tier1 = min($remaining, 8);
            $pay += $tier1 * 2 * $hourlyRate;
            $remaining -= $tier1;

            // Jam 9: 3x
            if ($remaining > 0) {
                $tier2 = min($remaining, 1);
                $pay += $tier2 * 3 * $hourlyRate;
                $remaining -= $tier2;
            }

            // Jam 10-11: 4x
            if ($remaining > 0) {
                $tier3 = min($remaining, 2);
                $pay += $tier3 * 4 * $hourlyRate;
                $remaining -= $tier3;
            }

            // Lebih dari jam 11: tetap 4x (asumsi lanjutan pola tertinggi)
            if ($remaining > 0) {
                $pay += $remaining * 4 * $hourlyRate;
            }
        } else {
            // Jam ke-1: 1.5x
            $tier1 = min($remaining, 1);
            $pay += $tier1 * 1.5 * $hourlyRate;
            $remaining -= $tier1;

            // Jam ke-2 dst: 2x
            if ($remaining > 0) {
                $pay += $remaining * 2 * $hourlyRate;
            }
        }

        return $pay;
    }

    public function submitLeave(Request $request)
    {
        $request->validate([
            'type' => 'required|in:izin,sakit',
            'reason' => 'required|string',
        ]);

        $user = $request->user();
        $today = Carbon::today()->toDateString();

        $existing = Attendance::where('user_id', $user->id)->where('date', $today)->first();
        if ($existing) {
            return response()->json(['message' => 'Sudah ada catatan absensi hari ini'], 400);
        }

        $attendance = Attendance::create([
            'user_id' => $user->id,
            'date' => $today,
            'status' => $request->type,
            'leave_reason' => $request->reason,
        ]);

        return response()->json(['message' => 'Pengajuan berhasil dicatat', 'data' => $attendance]);
    }
}
