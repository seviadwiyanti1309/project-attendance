import 'package:siabsen_app/features/admin/data/models/recap_model.dart';
import 'package:siabsen_app/features/admin/domain/entities/recap_entity.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../models/dashboard_summary_model.dart';
import '../models/employee_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final ApiClient apiClient;
  AdminRepositoryImpl(this.apiClient);

  @override
  Future<DashboardSummaryEntity> getDashboardSummary() async {
    final response = await apiClient.get(ApiConstants.dashboardSummary);
    return DashboardSummaryModel.fromJson(response);
  }

  @override
  Future<List<EmployeeEntity>> getEmployees() async {
    final response = await apiClient.get(ApiConstants.employees);
    return (response as List).map((e) => EmployeeModel.fromJson(e)).toList();
  }

  @override
  Future<List<RecapEntity>> getMonthlyRecap({required int month, required int year}) async {
    final response = await apiClient.get(
      ApiConstants.monthlyRecap,
      queryParams: {'month': month.toString(), 'year': year.toString()},
    );
    return (response as List).map((e) => RecapModel.fromJson(e)).toList();
  }

  @override
  Future<void> addEmployee({
    required String name,
    required String email,
    required String password,
    String? position,
    double? baseSalary,
  }) async {
    await apiClient.post(ApiConstants.employees, {
      'name': name,
      'email': email,
      'password': password,
      'position': position,
      'base_salary': baseSalary,
    });
  }
}