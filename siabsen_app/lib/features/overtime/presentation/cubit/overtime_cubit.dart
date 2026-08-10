import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_overtime_usecase.dart';
import '../../domain/usecases/get_overtime_history_usecase.dart';
import '../../../../core/network/api_exception.dart';
import 'overtime_state.dart';

class OvertimeCubit extends Cubit<OvertimeState> {
  final SubmitOvertimeUsecase submitOvertimeUsecase;
  final GetOvertimeHistoryUsecase getOvertimeHistoryUsecase;

  OvertimeCubit(this.submitOvertimeUsecase, this.getOvertimeHistoryUsecase) : super(OvertimeInitial());

  Future<void> submit({
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
  }) async {
    emit(OvertimeLoading());
    try {
      await submitOvertimeUsecase(date: date, startTime: startTime, endTime: endTime, reason: reason);
      emit(OvertimeSubmitSuccess());
      loadHistory();
    } on ApiException catch (e) {
      emit(OvertimeFailure(e.message));
    } catch (e) {
      emit(OvertimeFailure('Gagal mengajukan lembur'));
    }
  }

  Future<void> loadHistory() async {
    emit(OvertimeLoading());
    try {
      final items = await getOvertimeHistoryUsecase();
      emit(OvertimeHistoryLoaded(items));
    } on ApiException catch (e) {
      emit(OvertimeFailure(e.message));
    } catch (e) {
      emit(OvertimeFailure('Gagal memuat riwayat'));
    }
  }
}