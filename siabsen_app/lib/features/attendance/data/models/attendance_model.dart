import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({
    required super.id,
    required super.date,
    super.checkInTime,
    super.checkInPhoto,
    super.checkOutTime,
    super.checkOutPhoto,
    required super.status,
    required super.overtimeMinutes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      date: json['date'],
      checkInTime: json['check_in_time'],
      checkInPhoto: json['check_in_photo'],
      checkOutTime: json['check_out_time'],
      checkOutPhoto: json['check_out_photo'],
      status: json['status'] ?? 'alpha',
      overtimeMinutes: json['overtime_minutes'] ?? 0,
    );
  }
}