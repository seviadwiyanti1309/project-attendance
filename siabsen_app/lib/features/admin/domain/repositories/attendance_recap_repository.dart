import '../entities/attendance_recap.dart';

abstract class AttendanceRecapRepository {
  Future<List<AttendanceRecap>> getAllAttendances({
    String? date,
    int? month,
    int? year,
    String? status,
  });
}
