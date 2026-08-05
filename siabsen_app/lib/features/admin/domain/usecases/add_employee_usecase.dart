import '../repositories/admin_repository.dart';

class AddEmployeeUsecase {
  final AdminRepository repository;
  AddEmployeeUsecase(this.repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
    String? position,
    double? baseSalary,
  }) {
    return repository.addEmployee(
      name: name,
      email: email,
      password: password,
      position: position,
      baseSalary: baseSalary,
    );
  }
}