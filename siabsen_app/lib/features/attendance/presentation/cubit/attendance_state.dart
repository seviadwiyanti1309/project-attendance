import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_entity.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}
class AttendanceLoading extends AttendanceState {}
class CheckInSuccess extends AttendanceState {
  final AttendanceEntity data;
  CheckInSuccess(this.data);
  @override
  List<Object?> get props => [data];
}
class CheckOutSuccess extends AttendanceState {
  final AttendanceEntity data;
  CheckOutSuccess(this.data);
  @override
  List<Object?> get props => [data];
}
class HistoryLoaded extends AttendanceState {
  final List<AttendanceEntity> items;
  HistoryLoaded(this.items);
  @override
  List<Object?> get props => [items];
}
class AttendanceFailure extends AttendanceState {
  final String message;
  AttendanceFailure(this.message);
  @override
  List<Object?> get props => [message];
}