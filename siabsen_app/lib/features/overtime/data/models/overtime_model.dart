import '../../domain/entities/overtime_entity.dart';

class OvertimeModel extends OvertimeEntity {
  OvertimeModel({
    required super.id,
    required super.userId,
    super.employeeName,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.durationMinutes,
    required super.reason,
    required super.status,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic> json) {
    return OvertimeModel(
      id: json['id'],
      userId: json['user_id'],
      employeeName: json['user'] != null ? json['user']['name'] : null,
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      durationMinutes: json['duration_minutes'] ?? 0,
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}