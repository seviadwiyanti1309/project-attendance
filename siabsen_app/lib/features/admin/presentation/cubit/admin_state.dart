import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/employee_entity.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}
class AdminLoading extends AdminState {}
class DashboardLoaded extends AdminState {
  final DashboardSummaryEntity summary;
  DashboardLoaded(this.summary);
  @override
  List<Object?> get props => [summary];
}
class EmployeesLoaded extends AdminState {
  final List<EmployeeEntity> employees;
  EmployeesLoaded(this.employees);
  @override
  List<Object?> get props => [employees];
}
class EmployeeAddSuccess extends AdminState {}
class AdminFailure extends AdminState {
  final String message;
  AdminFailure(this.message);
  @override
  List<Object?> get props => [message];
}