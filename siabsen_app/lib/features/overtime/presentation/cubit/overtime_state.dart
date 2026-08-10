import 'package:equatable/equatable.dart';
import '../../domain/entities/overtime_entity.dart';

abstract class OvertimeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OvertimeInitial extends OvertimeState {}
class OvertimeLoading extends OvertimeState {}
class OvertimeSubmitSuccess extends OvertimeState {}
class OvertimeHistoryLoaded extends OvertimeState {
  final List<OvertimeEntity> items;
  OvertimeHistoryLoaded(this.items);
  @override
  List<Object?> get props => [items];
}
class OvertimeFailure extends OvertimeState {
  final String message;
  OvertimeFailure(this.message);
  @override
  List<Object?> get props => [message];
}