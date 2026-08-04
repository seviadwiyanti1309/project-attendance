<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class EmployeeController extends Controller
{
    public function index()
    {
        return response()->json(User::where('role', 'karyawan')->get());
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:6',
            'position' => 'nullable|string',
            'base_salary' => 'nullable|numeric',
            'standard_check_in' => 'nullable',
            'standard_check_out' => 'nullable',
        ]);

        $employee = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'karyawan',
            'position' => $request->position,
            'base_salary' => $request->base_salary ?? 0,
            'standard_check_in' => $request->standard_check_in ?? '08:00:00',
            'standard_check_out' => $request->standard_check_out ?? '17:00:00',
        ]);

        return response()->json($employee, 201);
    }

    public function update(Request $request, $id)
    {
        $employee = User::where('role', 'karyawan')->findOrFail($id);

        $employee->update($request->only([
            'name', 'position', 'base_salary', 'standard_check_in', 'standard_check_out'
        ]));

        return response()->json($employee);
    }

    public function destroy($id)
    {
        $employee = User::where('role', 'karyawan')->findOrFail($id);
        $employee->delete();

        return response()->json(['message' => 'Karyawan dihapus']);
    }
}
