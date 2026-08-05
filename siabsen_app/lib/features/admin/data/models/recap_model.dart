import '../../domain/entities/recap_entity.dart';

class RecapModel extends RecapEntity {
  RecapModel({
    required super.employeeId,
    required super.name,
    required super.totalHadir,
    required super.totalTelat,
    required super.totalOvertimeMinutes,
    required super.baseSalary,
    required super.estimatedOvertimePay,
    required super.estimatedTotalSalary,
  });

  factory RecapModel.fromJson(Map<String, dynamic> json) {
    return RecapModel(
      employeeId: json['employee_id'],
      name: json['name'],
      totalHadir: json['total_hadir'] ?? 0,
      totalTelat: json['total_telat'] ?? 0,
      totalOvertimeMinutes: json['total_overtime_minutes'] ?? 0,
      baseSalary: double.tryParse(json['base_salary'].toString()) ?? 0,
      estimatedOvertimePay: double.tryParse(json['estimated_overtime_pay'].toString()) ?? 0,
      estimatedTotalSalary: double.tryParse(json['estimated_total_salary'].toString()) ?? 0,
    );
  }
}