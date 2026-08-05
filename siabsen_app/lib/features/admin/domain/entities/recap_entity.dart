class RecapEntity {
  final int employeeId;
  final String name;
  final int totalHadir;
  final int totalTelat;
  final int totalOvertimeMinutes;
  final double baseSalary;
  final double estimatedOvertimePay;
  final double estimatedTotalSalary;

  RecapEntity({
    required this.employeeId,
    required this.name,
    required this.totalHadir,
    required this.totalTelat,
    required this.totalOvertimeMinutes,
    required this.baseSalary,
    required this.estimatedOvertimePay,
    required this.estimatedTotalSalary,
  });
}