class ProfileEntity {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? position;
  final double baseSalary;
  final String standardCheckIn;
  final String standardCheckOut;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.position,
    required this.baseSalary,
    required this.standardCheckIn,
    required this.standardCheckOut,
  });
}