import '../repositories/admin_repository.dart';

class DeleteEmployeeUsecase {
  final AdminRepository repository;
  DeleteEmployeeUsecase(this.repository);
  Future<void> call(int id) => repository.deleteEmployee(id);
}