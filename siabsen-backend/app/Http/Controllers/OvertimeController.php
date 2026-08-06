<?php

namespace App\Http\Controllers;

use App\Models\OvertimeRequest;
use Illuminate\Http\Request;
use Carbon\Carbon;

class OvertimeController extends Controller
{
    public function submit(Request $request)
    {
        $request->validate([
            'date' => 'required|date',
            'start_time' => 'required',
            'end_time' => 'required',
            'reason' => 'required|string',
        ]);

        $start = Carbon::parse($request->start_time);
        $end = Carbon::parse($request->end_time);
        $durationMinutes = $end->diffInMinutes($start);

        if ($durationMinutes <= 0) {
            return response()->json(['message' => 'Jam selesai harus setelah jam mulai'], 400);
        }

        $overtime = OvertimeRequest::create([
            'user_id' => $request->user()->id,
            'date' => $request->date,
            'start_time' => $request->start_time,
            'end_time' => $request->end_time,
            'duration_minutes' => $durationMinutes,
            'reason' => $request->reason,
            'status' => 'pending',
        ]);

        return response()->json(['message' => 'Pengajuan lembur berhasil dikirim', 'data' => $overtime], 201);
    }

    public function history(Request $request)
    {
        $overtimes = OvertimeRequest::where('user_id', $request->user()->id)
            ->orderBy('date', 'desc')
            ->get();

        return response()->json($overtimes);
    }

    public function pendingList()
    {
        $overtimes = OvertimeRequest::with('user:id,name,position')
            ->where('status', 'pending')
            ->orderBy('date', 'asc')
            ->get();

        return response()->json($overtimes);
    }

    public function approve(Request $request, $id)
    {
        $overtime = OvertimeRequest::findOrFail($id);
        $overtime->update([
            'status' => 'approved',
            'reviewed_by' => $request->user()->id,
            'reviewed_at' => now(),
        ]);

        return response()->json(['message' => 'Lembur disetujui', 'data' => $overtime]);
    }

    public function reject(Request $request, $id)
    {
        $overtime = OvertimeRequest::findOrFail($id);
        $overtime->update([
            'status' => 'rejected',
            'reviewed_by' => $request->user()->id,
            'reviewed_at' => now(),
        ]);

        return response()->json(['message' => 'Lembur ditolak', 'data' => $overtime]);
    }
}