<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AttendanceController;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', fn (Illuminate\Http\Request $request) => $request->user());

    Route::post('/check-in', [AttendanceController::class, 'checkIn']);
    Route::post('/check-out', [AttendanceController::class, 'checkOut']);
    Route::get('/attendances/history', [AttendanceController::class, 'history']);
    Route::get('/attendances/all', [AttendanceController::class, 'allAttendances']);
    Route::get('/dashboard/summary', [AttendanceController::class, 'dashboardSummary']);
});