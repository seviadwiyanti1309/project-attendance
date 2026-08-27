import '../../domain/entities/attendance_recap.dart';
import '../../domain/repositories/attendance_recap_repository.dart';
import '../datasources/attendance_recap_remote_datasource.dart';

class AttendanceRecapRepositoryImpl implements AttendanceRecapRepository {
  final AttendanceRecapRemoteDataSource remoteDataSource;
  AttendanceRecapRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AttendanceRecap>> getAllAttendances({
    String? date,
    int? month,
    int? year,
    String? status,
  }) {
    return remoteDataSource.getAllAttendances(
      date: date,
      month: month,
      year: year,
      status: status,
    );
  }
}
