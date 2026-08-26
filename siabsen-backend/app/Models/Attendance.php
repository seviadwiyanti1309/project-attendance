<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    protected $fillable = [
        'user_id',
        'date',
        'check_in_time',
        'check_in_photo',
        'check_in_latitude',
        'check_in_longitude',
        'check_in_address',
        'check_out_time',
        'check_out_photo',
        'check_out_latitude',
        'check_out_longitude',
        'check_out_address',
        'status',
        'overtime_minutes',
        'reason',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
