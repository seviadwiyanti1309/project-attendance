import '../repositories/overtime_repository.dart';

class ReviewOvertimeUsecase {
  final OvertimeRepository repository;
  ReviewOvertimeUsecase(this.repository);

  Future<void> approve(int id) => repository.approve(id);
  Future<void> reject(int id) => repository.reject(id);
}