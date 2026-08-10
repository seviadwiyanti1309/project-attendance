import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class SubmitLeaveUsecase {
  final AttendanceRepository repository;
  SubmitLeaveUsecase(this.repository);
  Future<AttendanceEntity> call({required String type, required String reason}) {
    return repository.submitLeave(type: type, reason: reason);
  }
}