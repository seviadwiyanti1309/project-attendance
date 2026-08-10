import '../entities/overtime_entity.dart';

abstract class OvertimeRepository {
  Future<void> submit({
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
  });
  Future<List<OvertimeEntity>> getHistory();
  Future<List<OvertimeEntity>> getPendingList();
  Future<void> approve(int id);
  Future<void> reject(int id);
}