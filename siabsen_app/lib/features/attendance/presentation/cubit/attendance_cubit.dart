import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siabsen_app/features/attendance/domain/usecases/submit_leave_usecase.dart';
import '../../domain/usecases/check_in_usecase.dart';
import '../../domain/usecases/check_out_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../../../core/network/api_exception.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final CheckInUsecase checkInUsecase;
  final CheckOutUsecase checkOutUsecase;
  final GetHistoryUsecase getHistoryUsecase;
   final SubmitLeaveUsecase submitLeaveUsecase;

  AttendanceCubit(this.checkInUsecase, this.checkOutUsecase, this.getHistoryUsecase, this.submitLeaveUsecase)
      : super(AttendanceInitial());

  Future<void> checkIn(String photoPath) async {
    emit(AttendanceLoading());
    try {
      final data = await checkInUsecase(photoPath);
      emit(CheckInSuccess(data));
    } on ApiException catch (e) {
      emit(AttendanceFailure(e.message));
    } catch (e) {
      emit(AttendanceFailure('Gagal check-in, coba lagi'));
    }
  }

  Future<void> checkOut(String photoPath) async {
    emit(AttendanceLoading());
    try {
      final data = await checkOutUsecase(photoPath);
      emit(CheckOutSuccess(data));
    } on ApiException catch (e) {
      emit(AttendanceFailure(e.message));
    } catch (e) {
      emit(AttendanceFailure('Gagal check-out, coba lagi'));
    }
  }

  Future<void> loadHistory() async {
    emit(AttendanceLoading());
    try {
      final items = await getHistoryUsecase();
      emit(HistoryLoaded(items));
    } on ApiException catch (e) {
      emit(AttendanceFailure(e.message));
    } catch (e) {
      emit(AttendanceFailure('Gagal memuat riwayat'));
    }
  }
  
 Future<void> submitLeave({required String type, required String reason}) async {
  emit(AttendanceLoading());
  try {
    final data = await submitLeaveUsecase(type: type, reason: reason);
    emit(LeaveSubmitSuccess(data));
  } on ApiException catch (e) {
    emit(AttendanceFailure(e.message));
  } catch (e) {
    emit(AttendanceFailure('Gagal mengajukan izin/sakit'));
  }
}
}