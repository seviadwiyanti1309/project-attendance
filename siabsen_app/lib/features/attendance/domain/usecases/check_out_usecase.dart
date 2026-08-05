import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class CheckOutUsecase {
  final AttendanceRepository repository;
  CheckOutUsecase(this.repository);
  Future<AttendanceEntity> call(String photoPath) => repository.checkOut(photoPath);
}