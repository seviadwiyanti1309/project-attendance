<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\EmployeeController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\OvertimeController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', fn (Illuminate\Http\Request $request) => $request->user());
    Route::post('/overtime/submit', [OvertimeController::class, 'submit']);
    Route::get('/overtime/history', [OvertimeController::class, 'history']);

    // Bisa diakses karyawan & admin
    Route::post('/check-in', [AttendanceController::class, 'checkIn']);
    Route::post('/check-out', [AttendanceController::class, 'checkOut']);
    Route::get('/attendances/history', [AttendanceController::class, 'history']);
    Route::post('/attendances/leave', [AttendanceController::class, 'submitLeave']);

    // Khusus admin - harus SEBELUM route {id}
    Route::middleware('admin')->group(function () {
        Route::get('/attendances/all', [AttendanceController::class, 'allAttendances']);
        Route::get('/attendances/monthly-recap', [AttendanceController::class, 'monthlyRecap']);
        Route::get('/dashboard/summary', [AttendanceController::class, 'dashboardSummary']);

        Route::get('/employees', [EmployeeController::class, 'index']);
        Route::post('/employees', [EmployeeController::class, 'store']);
        Route::put('/employees/{id}', [EmployeeController::class, 'update']);
        Route::delete('/employees/{id}', [EmployeeController::class, 'destroy']);

        Route::get('/overtime/pending', [OvertimeController::class, 'pendingList']);
        Route::put('/overtime/{id}/approve', [OvertimeController::class, 'approve']);
        Route::put('/overtime/{id}/reject', [OvertimeController::class, 'reject']);
    });

    // Route dengan parameter dinamis - HARUS di bawah semua route spesifik!
    Route::get('/attendances/{id}', [AttendanceController::class, 'show']);
});
