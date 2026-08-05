import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class GetHistoryUsecase {
  final AttendanceRepository repository;
  GetHistoryUsecase(this.repository);
  Future<List<AttendanceEntity>> call() => repository.getHistory();
}