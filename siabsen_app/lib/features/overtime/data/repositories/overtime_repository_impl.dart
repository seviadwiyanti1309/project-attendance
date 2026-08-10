import '../../../../core/network/api_client.dart';
import '../../domain/entities/overtime_entity.dart';
import '../../domain/repositories/overtime_repository.dart';
import '../models/overtime_model.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  final ApiClient apiClient;
  OvertimeRepositoryImpl(this.apiClient);

  @override
  Future<void> submit({
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
  }) async {
    await apiClient.post('/overtime/submit', {
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'reason': reason,
    });
  }

  @override
  Future<List<OvertimeEntity>> getHistory() async {
    final response = await apiClient.get('/overtime/history');
    return (response as List).map((e) => OvertimeModel.fromJson(e)).toList();
  }

  @override
  Future<List<OvertimeEntity>> getPendingList() async {
    final response = await apiClient.get('/overtime/pending');
    return (response as List).map((e) => OvertimeModel.fromJson(e)).toList();
  }

  @override
  Future<void> approve(int id) async {
    await apiClient.put('/overtime/$id/approve', {});
  }

  @override
  Future<void> reject(int id) async {
    await apiClient.put('/overtime/$id/reject', {});
  }
}