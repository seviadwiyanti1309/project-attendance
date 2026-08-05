import '../entities/dashboard_summary_entity.dart';
import '../entities/employee_entity.dart';
import '../entities/recap_entity.dart';

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
  Future<List<RecapEntity>> getMonthlyRecap({required int month, required int year});
}