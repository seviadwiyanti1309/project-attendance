import '../entities/dashboard_summary_entity.dart';
import '../entities/employee_entity.dart';

abstract class AdminRepository {
  Future<DashboardSummaryEntity> getDashboardSummary();
  Future<List<EmployeeEntity>> getEmployees();
  Future<void> addEmployee({
    required String name,
    required String email,
    required String password,
    String? position,
    double? baseSalary,
  });
}