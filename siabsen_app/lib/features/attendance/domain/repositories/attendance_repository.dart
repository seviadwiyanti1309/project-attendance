import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity> checkIn(String photoPath);
  Future<AttendanceEntity> checkOut(String photoPath);
  Future<List<AttendanceEntity>> getHistory();
}