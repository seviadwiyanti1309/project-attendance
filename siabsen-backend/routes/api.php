<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\EmployeeController;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', fn (Illuminate\Http\Request $request) => $request->user());

    // Bisa diakses karyawan & admin
    Route::post('/check-in', [AttendanceController::class, 'checkIn']);
    Route::post('/check-out', [AttendanceController::class, 'checkOut']);
    Route::get('/attendances/history', [AttendanceController::class, 'history']);

    // Khusus admin
    Route::middleware('admin')->group(function () {
        Route::get('/attendances/all', [AttendanceController::class, 'allAttendances']);
        Route::get('/dashboard/summary', [AttendanceController::class, 'dashboardSummary']);
        Route::get('/attendances/monthly-recap', [AttendanceController::class, 'monthlyRecap']);

        Route::get('/employees', [EmployeeController::class, 'index']);
        Route::post('/employees', [EmployeeController::class, 'store']);
        Route::put('/employees/{id}', [EmployeeController::class, 'update']);
        Route::delete('/employees/{id}', [EmployeeController::class, 'destroy']);
    });
});