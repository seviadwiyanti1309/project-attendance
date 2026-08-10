import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_pending_overtime_usecase.dart';
import '../../domain/usecases/review_overtime_usecase.dart';
import '../../../../core/network/api_exception.dart';
import 'overtime_approval_state.dart';

class OvertimeApprovalCubit extends Cubit<OvertimeApprovalState> {
  final GetPendingOvertimeUsecase getPendingOvertimeUsecase;
  final ReviewOvertimeUsecase reviewOvertimeUsecase;

  OvertimeApprovalCubit(this.getPendingOvertimeUsecase, this.reviewOvertimeUsecase) : super(ApprovalInitial());

  Future<void> loadPending() async {
    emit(ApprovalLoading());
    try {
      final items = await getPendingOvertimeUsecase();
      emit(PendingLoaded(items));
    } on ApiException catch (e) {
      emit(ApprovalFailure(e.message));
    } catch (e) {
      emit(ApprovalFailure('Gagal memuat data'));
    }
  }

  Future<void> approve(int id) async {
    try {
      await reviewOvertimeUsecase.approve(id);
      loadPending();
    } on ApiException catch (e) {
      emit(ApprovalFailure(e.message));
    }
  }

  Future<void> reject(int id) async {
    try {
      await reviewOvertimeUsecase.reject(id);
      loadPending();
    } on ApiException catch (e) {
      emit(ApprovalFailure(e.message));
    }
  }
}