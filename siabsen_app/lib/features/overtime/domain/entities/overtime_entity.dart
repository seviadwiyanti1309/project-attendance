class OvertimeEntity {
  final int id;
  final int userId;
  final String? employeeName;
  final String date;
  final String startTime;
  final String endTime;
  final int durationMinutes;
  final String reason;
  final String status;

  OvertimeEntity({
    required this.id,
    required this.userId,
    this.employeeName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.reason,
    required this.status,
  });
}