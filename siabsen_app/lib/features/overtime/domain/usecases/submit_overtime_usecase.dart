import '../repositories/overtime_repository.dart';

class SubmitOvertimeUsecase {
  final OvertimeRepository repository;
  SubmitOvertimeUsecase(this.repository);

  Future<void> call({
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
  }) {
    return repository.submit(date: date, startTime: startTime, endTime: endTime, reason: reason);
  }
}