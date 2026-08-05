import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class CheckInUsecase {
  final AttendanceRepository repository;
  CheckInUsecase(this.repository);
  Future<AttendanceEntity> call(String photoPath) => repository.checkIn(photoPath);
}