class EmployeeEntity {
  final int id;
  final String name;
  final String email;
  final String? position;
  final double baseSalary;

  EmployeeEntity({
    required this.id,
    required this.name,
    required this.email,
    this.position,
    required this.baseSalary,
  });
}