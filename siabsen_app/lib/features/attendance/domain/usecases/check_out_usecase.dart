import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class CheckOutUsecase {
  final AttendanceRepository repository;
  CheckOutUsecase(this.repository);
  Future<AttendanceEntity> call({
    required String photoPath,
    required double latitude,
    required double longitude,
  }) =>
      repository.checkOut(
        photoPath: photoPath,
        latitude: latitude,
        longitude: longitude,
      );
}