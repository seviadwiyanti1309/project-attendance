import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final ApiClient apiClient;
  AttendanceRepositoryImpl(this.apiClient);

  @override
  Future<AttendanceEntity> checkIn(String photoPath) async {
    final response = await apiClient.multipartPost(
      ApiConstants.checkIn, {}, photoPath, 'photo',
    );
    return AttendanceModel.fromJson(response['data']);
  }

  @override
  Future<AttendanceEntity> checkOut(String photoPath) async {
    final response = await apiClient.multipartPost(
      ApiConstants.checkOut, {}, photoPath, 'photo',
    );
    return AttendanceModel.fromJson(response['data']);
  }

  @override
  Future<List<AttendanceEntity>> getHistory() async {
    final response = await apiClient.get(ApiConstants.history);
    return (response as List).map((e) => AttendanceModel.fromJson(e)).toList();
  }
}