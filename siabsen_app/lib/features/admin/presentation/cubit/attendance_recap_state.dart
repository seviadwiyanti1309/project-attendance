import '../../domain/entities/attendance_recap.dart'; // sesuaikan nama entity file km, misal 'recap_entity.dart'

abstract class AttendanceRecapState {}

class AttendanceRecapInitial extends AttendanceRecapState {}

class AttendanceRecapLoading extends AttendanceRecapState {}

class AttendanceRecapLoaded extends AttendanceRecapState {
  final List<AttendanceRecap> attendances;
  AttendanceRecapLoaded(this.attendances);
}

class AttendanceRecapFailure extends AttendanceRecapState {
  final String message;
  AttendanceRecapFailure(this.message);
}
