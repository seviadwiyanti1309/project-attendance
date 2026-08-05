import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  EmployeeModel({
    required super.id,
    required super.name,
    required super.email,
    super.position,
    required super.baseSalary,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      position: json['position'],
      baseSalary: double.tryParse(json['base_salary'].toString()) ?? 0,
    );
  }
}