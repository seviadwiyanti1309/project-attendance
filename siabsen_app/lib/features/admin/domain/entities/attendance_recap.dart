class AttendanceRecap {
  final int id;
  final int userId;
  final String userName;
  final String? userPosition;
  final String date;
  final String? checkInTime;
  final String? checkInPhoto;
  final String? checkInAddress;
  final String? checkOutTime;
  final String? checkOutPhoto;
  final String? checkOutAddress;
  final String status;
  final int overtimeMinutes;
  final String? reason;

  const AttendanceRecap({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPosition,
    required this.date,
    this.checkInTime,
    this.checkInPhoto,
    this.checkInAddress,
    this.checkOutTime,
    this.checkOutPhoto,
    this.checkOutAddress,
    required this.status,
    required this.overtimeMinutes,
    this.reason,
  });
}
