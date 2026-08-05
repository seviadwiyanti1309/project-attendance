import '../entities/employee_entity.dart';
import '../repositories/admin_repository.dart';

class GetEmployeesUsecase {
  final AdminRepository repository;
  GetEmployeesUsecase(this.repository);
  Future<List<EmployeeEntity>> call() => repository.getEmployees();
}