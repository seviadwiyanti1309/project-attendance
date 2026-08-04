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

            $totalOvertimeMinutes = $attendances->sum('overtime_minutes');
            $totalHadir = $attendances->count();
            $totalTelat = $attendances->where('status', 'telat')->count();

            $hourlyRate = $employee->base_salary / 173; // 173 = rata-rata jam kerja/bulan
            $overtimePay = ($totalOvertimeMinutes / 60) * $hourlyRate * 1.5;

            return [
                'employee_id' => $employee->id,
                'name' => $employee->name,
                'total_hadir' => $totalHadir,
                'total_telat' => $totalTelat,
                'total_overtime_minutes' => $totalOvertimeMinutes,
                'base_salary' => $employee->base_salary,
                'estimated_overtime_pay' => round($overtimePay, 2),
                'estimated_total_salary' => round($employee->base_salary + $overtimePay, 2),
            ];
        });

        return response()->json($recap);
    }
}
