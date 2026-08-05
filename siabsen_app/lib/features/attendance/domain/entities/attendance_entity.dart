class AttendanceEntity {
  final int id;
  final String date;
  final String? checkInTime;
  final String? checkInPhoto;
  final String? checkOutTime;
  final String? checkOutPhoto;
  final String status;
  final int overtimeMinutes;

  AttendanceEntity({
    required this.id,
    required this.date,
    this.checkInTime,
    this.checkInPhoto,
    this.checkOutTime,
    this.checkOutPhoto,
    required this.status,
    required this.overtimeMinutes,
  });
}