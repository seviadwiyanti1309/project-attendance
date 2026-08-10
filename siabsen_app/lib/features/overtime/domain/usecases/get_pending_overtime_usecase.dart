import '../entities/overtime_entity.dart';
import '../repositories/overtime_repository.dart';

class GetPendingOvertimeUsecase {
  final OvertimeRepository repository;
  GetPendingOvertimeUsecase(this.repository);
  Future<List<OvertimeEntity>> call() => repository.getPendingList();
}