import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity> checkIn({
    required String photoPath,
    required double latitude,
    required double longitude,
  });
  Future<AttendanceEntity> checkOut({
    required String photoPath,
    required double latitude,
    required double longitude,
  });
  Future<List<AttendanceEntity>> getHistory();
  Future<AttendanceEntity> submitLeave({required String type, required String reason});
}