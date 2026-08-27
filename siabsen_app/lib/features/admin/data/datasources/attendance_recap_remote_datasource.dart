import '../../../../core/network/api_client.dart';
import '../models/attendance_recap_model.dart';

class AttendanceRecapRemoteDataSource {
  final ApiClient apiClient;
  AttendanceRecapRemoteDataSource(this.apiClient);

  Future<List<AttendanceRecapModel>> getAllAttendances({
    String? date,
    int? month,
    int? year,
    String? status,
  }) async {
    final queryParams = <String, String>{};
    if (date != null) queryParams['date'] = date;
    if (month != null) queryParams['month'] = month.toString();
    if (year != null) queryParams['year'] = year.toString();
    if (status != null) queryParams['status'] = status;

    final response = await apiClient.get(
      '/attendances/all',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List)
        .map((e) => AttendanceRecapModel.fromJson(e))
        .toList();
  }
}
