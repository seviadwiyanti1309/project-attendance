import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_in_usecase.dart';
import '../../domain/usecases/check_out_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../../../core/network/api_exception.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final CheckInUsecase checkInUsecase;
  final CheckOutUsecase checkOutUsecase;
  final GetHistoryUsecase getHistoryUsecase;

  AttendanceCubit(this.checkInUsecase, this.checkOutUsecase, this.getHistoryUsecase)
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
}