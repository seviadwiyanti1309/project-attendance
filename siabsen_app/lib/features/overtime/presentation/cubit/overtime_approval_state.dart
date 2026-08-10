import 'package:equatable/equatable.dart';
import '../../domain/entities/overtime_entity.dart';

abstract class OvertimeApprovalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApprovalInitial extends OvertimeApprovalState {}
class ApprovalLoading extends OvertimeApprovalState {}
class PendingLoaded extends OvertimeApprovalState {
  final List<OvertimeEntity> items;
  PendingLoaded(this.items);
  @override
  List<Object?> get props => [items];
}
class ApprovalFailure extends OvertimeApprovalState {
  final String message;
  ApprovalFailure(this.message);
  @override
  List<Object?> get props => [message];
}