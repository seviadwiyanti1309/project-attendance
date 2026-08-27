import '../entities/attendance_recap.dart';
import '../repositories/attendance_recap_repository.dart';

class GetAllAttendances {
  final AttendanceRecapRepository repository;
  GetAllAttendances(this.repository);

  Future<List<AttendanceRecap>> call({
    String? date,
    int? month,
    int? year,
    String? status,
  }) {
    return repository.getAllAttendances(
      date: date,
      month: month,
      year: year,
      status: status,
    );
  }
}
