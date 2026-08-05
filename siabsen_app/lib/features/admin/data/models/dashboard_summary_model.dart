import '../../domain/entities/dashboard_summary_entity.dart';

class DashboardSummaryModel extends DashboardSummaryEntity {
  DashboardSummaryModel({
    required super.totalKaryawan,
    required super.hadirHariIni,
    required super.belumHadir,
    required super.telatHariIni,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalKaryawan: json['total_karyawan'] ?? 0,
      hadirHariIni: json['hadir_hari_ini'] ?? 0,
      belumHadir: json['belum_hadir'] ?? 0,
      telatHariIni: json['telat_hari_ini'] ?? 0,
    );
  }
}