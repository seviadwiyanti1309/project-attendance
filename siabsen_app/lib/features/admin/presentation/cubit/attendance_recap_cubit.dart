import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_attendances.dart';
import 'attendance_recap_state.dart';

class AttendanceRecapCubit extends Cubit<AttendanceRecapState> {
  final GetAllAttendances getAllAttendances;
  AttendanceRecapCubit(this.getAllAttendances)
    : super(AttendanceRecapInitial());

  Future<void> loadAttendances({
    String? date,
    int? month,
    int? year,
    String? status,
  }) async {
    emit(AttendanceRecapLoading());
    try {
      final data = await getAllAttendances(
        date: date,
        month: month,
        year: year,
        status: status,
      );
      emit(AttendanceRecapLoaded(data));
    } catch (e) {
      emit(AttendanceRecapFailure(e.toString()));
    }
  }
}
