import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final ApiClient apiClient;
  AttendanceRepositoryImpl(this.apiClient);

  @override
  Future<AttendanceEntity> checkIn({
    required String photoPath,
    required double latitude,
    required double longitude,
  }) async {
    final response = await apiClient.multipartPost(
      ApiConstants.checkIn,
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
      photoPath,
      'photo',
    );
    return AttendanceModel.fromJson(response['data']);
  }

  @override
  Future<AttendanceEntity> checkOut({
    required String photoPath,
    required double latitude,
    required double longitude,
  }) async {
    final response = await apiClient.multipartPost(
      ApiConstants.checkOut,
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
      photoPath,
      'photo',
    );
    return AttendanceModel.fromJson(response['data']);
  }

  @override
  Future<List<AttendanceEntity>> getHistory() async {
    final response = await apiClient.get(ApiConstants.history);
    return (response as List).map((e) => AttendanceModel.fromJson(e)).toList();
  }

  @override
  Future<AttendanceEntity> submitLeave({required String type, required String reason}) async {
    final response = await apiClient.post('/attendances/leave', {'type': type, 'reason': reason});
    return AttendanceModel.fromJson(response['data']);
  }
}