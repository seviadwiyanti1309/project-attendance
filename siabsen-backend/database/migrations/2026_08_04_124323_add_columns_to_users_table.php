<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->enum('role', ['karyawan', 'admin'])->default('karyawan');
            $table->string('position')->nullable();
            $table->decimal('base_salary', 12, 2)->default(0);
            $table->time('standard_check_in')->default('08:00:00');
            $table->time('standard_check_out')->default('17:00:00');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['role', 'position', 'base_salary', 'standard_check_in', 'standard_check_out']);
        });
    }
};
