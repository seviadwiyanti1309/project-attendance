<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    protected $fillable = [
        'user_id', 'date', 'check_in_time', 'check_in_photo',
        'check_out_time', 'check_out_photo', 'status', 'overtime_minutes'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
