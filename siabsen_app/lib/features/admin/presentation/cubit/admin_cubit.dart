import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/get_employees_usecase.dart';
import '../../domain/usecases/add_employee_usecase.dart';
import '../../../../core/network/api_exception.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetDashboardSummaryUsecase getDashboardSummaryUsecase;
  final GetEmployeesUsecase getEmployeesUsecase;
  final AddEmployeeUsecase addEmployeeUsecase;

  AdminCubit(this.getDashboardSummaryUsecase, this.getEmployeesUsecase, this.addEmployeeUsecase)
      : super(AdminInitial());

  Future<void> loadDashboard() async {
    emit(AdminLoading());
    try {
      final summary = await getDashboardSummaryUsecase();
      emit(DashboardLoaded(summary));
    } on ApiException catch (e) {
      emit(AdminFailure(e.message));
    } catch (e) {
      emit(AdminFailure('Gagal memuat dashboard'));
    }
  }

  Future<void> loadEmployees() async {
    emit(AdminLoading());
    try {
      final employees = await getEmployeesUsecase();
      emit(EmployeesLoaded(employees));
    } on ApiException catch (e) {
      emit(AdminFailure(e.message));
    } catch (e) {
      emit(AdminFailure('Gagal memuat daftar karyawan'));
    }
  }

  Future<void> addEmployee({
    required String name,
    required String email,
    required String password,
    String? position,
    double? baseSalary,
  }) async {
    emit(AdminLoading());
    try {
      await addEmployeeUsecase(
        name: name, email: email, password: password,
        position: position, baseSalary: baseSalary,
      );
      emit(EmployeeAddSuccess());
      loadEmployees();
    } on ApiException catch (e) {
      emit(AdminFailure(e.message));
    } catch (e) {
      emit(AdminFailure('Gagal menambah karyawan'));
    }
  }
}