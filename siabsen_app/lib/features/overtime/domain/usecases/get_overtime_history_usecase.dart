import '../entities/overtime_entity.dart';
import '../repositories/overtime_repository.dart';

class GetOvertimeHistoryUsecase {
  final OvertimeRepository repository;
  GetOvertimeHistoryUsecase(this.repository);
  Future<List<OvertimeEntity>> call() => repository.getHistory();
}