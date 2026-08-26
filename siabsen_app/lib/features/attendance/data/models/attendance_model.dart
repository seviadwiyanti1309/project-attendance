import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({
    required super.id,
    required super.date,
    super.checkInTime,
    super.checkInPhoto,
    super.checkInLatitude,
    super.checkInLongitude,
    super.checkInAddress,
    super.checkOutTime,
    super.checkOutPhoto,
    super.checkOutLatitude,
    super.checkOutLongitude,
    super.checkOutAddress,
    required super.status,
    required super.overtimeMinutes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      date: json['date'],
      checkInTime: json['check_in_time'],
      checkInPhoto: json['check_in_photo'],
      checkInLatitude: json['check_in_latitude'] != null
          ? double.tryParse(json['check_in_latitude'].toString())
          : (json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null),
      checkInLongitude: json['check_in_longitude'] != null
          ? double.tryParse(json['check_in_longitude'].toString())
          : (json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null),
      checkInAddress: json['check_in_address'] ?? json['address'],
      checkOutTime: json['check_out_time'],
      checkOutPhoto: json['check_out_photo'],
      checkOutLatitude: json['check_out_latitude'] != null
          ? double.tryParse(json['check_out_latitude'].toString())
          : null,
      checkOutLongitude: json['check_out_longitude'] != null
          ? double.tryParse(json['check_out_longitude'].toString())
          : null,
      checkOutAddress: json['check_out_address'],
      status: json['status'] ?? 'alpha',
      overtimeMinutes: json['overtime_minutes'] ?? 0,
    );
  }
}