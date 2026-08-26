import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class CheckInUsecase {
  final AttendanceRepository repository;
  CheckInUsecase(this.repository);
  Future<AttendanceEntity> call({
    required String photoPath,
    required double latitude,
    required double longitude,
  }) =>
      repository.checkIn(
        photoPath: photoPath,
        latitude: latitude,
        longitude: longitude,
      );
}