class AttendanceEntity {
  final int id;
  final String date;
  final String? checkInTime;
  final String? checkInPhoto;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final String? checkInAddress;
  final String? checkOutTime;
  final String? checkOutPhoto;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final String? checkOutAddress;
  final String status;
  final int overtimeMinutes;

  AttendanceEntity({
    required this.id,
    required this.date,
    this.checkInTime,
    this.checkInPhoto,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkInAddress,
    this.checkOutTime,
    this.checkOutPhoto,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutAddress,
    required this.status,
    required this.overtimeMinutes,
  });
}