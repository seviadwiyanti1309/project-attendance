import '../entities/dashboard_summary_entity.dart';
import '../repositories/admin_repository.dart';

class GetDashboardSummaryUsecase {
  final AdminRepository repository;
  GetDashboardSummaryUsecase(this.repository);
  Future<DashboardSummaryEntity> call() => repository.getDashboardSummary();
}