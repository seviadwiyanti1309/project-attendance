import '../entities/recap_entity.dart';
import '../repositories/admin_repository.dart';

class GetMonthlyRecapUsecase {
  final AdminRepository repository;
  GetMonthlyRecapUsecase(this.repository);
  Future<List<RecapEntity>> call({required int month, required int year}) {
    return repository.getMonthlyRecap(month: month, year: year);
  }
}