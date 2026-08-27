import '../../domain/entities/attendance_recap.dart';

class AttendanceRecapModel extends AttendanceRecap {
  const AttendanceRecapModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.userPosition,
    required super.date,
    super.checkInTime,
    super.checkInPhoto,
    super.checkInAddress,
    super.checkOutTime,
    super.checkOutPhoto,
    super.checkOutAddress,
    required super.status,
    required super.overtimeMinutes,
    super.reason,
  });

  factory AttendanceRecapModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return AttendanceRecapModel(
      id: json['id'],
      userId: json['user_id'],
      userName: user['name'] ?? '-',
      userPosition: user['position'],
      date: json['date'] ?? '',
      checkInTime: json['check_in_time'],
      checkInPhoto: json['check_in_photo'],
      checkInAddress: json['check_in_address'],
      checkOutTime: json['check_out_time'],
      checkOutPhoto: json['check_out_photo'],
      checkOutAddress: json['check_out_address'],
      status: json['status'] ?? '-',
      overtimeMinutes: json['overtime_minutes'] ?? 0,
      reason: json['reason'],
    );
  }
}
