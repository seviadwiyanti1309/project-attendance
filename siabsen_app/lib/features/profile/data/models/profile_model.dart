import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.position,
    required super.baseSalary,
    required super.standardCheckIn,
    required super.standardCheckOut,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      position: json['position'],
      baseSalary: double.tryParse(json['base_salary'].toString()) ?? 0,
      standardCheckIn: json['standard_check_in'] ?? '08:00:00',
      standardCheckOut: json['standard_check_out'] ?? '17:00:00',
    );
  }
}