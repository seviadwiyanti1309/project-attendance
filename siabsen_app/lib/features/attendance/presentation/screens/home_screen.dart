import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _handleCheckIn(BuildContext context) async {
    final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (photo != null && context.mounted) {
      context.read<AttendanceCubit>().checkIn(photo.path);
    }
  }

  Future<void> _handleCheckOut(BuildContext context) async {
    final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (photo != null && context.mounted) {
      context.read<AttendanceCubit>().checkOut(photo.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>()..loadHistory(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<AttendanceCubit, AttendanceState>(
          listener: (context, state) {
            if (state is CheckInSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Check-in berhasil'), backgroundColor: AppColors.success),
              );
              context.read<AttendanceCubit>().loadHistory();
            } else if (state is CheckOutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Check-out berhasil'), backgroundColor: AppColors.success),
              );
              context.read<AttendanceCubit>().loadHistory();
            } else if (state is AttendanceFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.danger),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AttendanceLoading;
            final history = state is HistoryLoaded ? state.items : <dynamic>[];
            final today = history.isNotEmpty ? history.first : null;

            return RefreshIndicator(
              onRefresh: () async => context.read<AttendanceCubit>().loadHistory(),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Absen Hari Ini',
                          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                label: 'Check In',
                                icon: Icons.login_rounded,
                                color: AppColors.primary,
                                enabled: today?.checkInTime == null,
                                loading: isLoading,
                                onTap: () => _handleCheckIn(context),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                label: 'Check Out',
                                icon: Icons.logout_rounded,
                                color: AppColors.primaryDark,
                                enabled: today?.checkInTime != null && today?.checkOutTime == null,
                                loading: isLoading,
                                onTap: () => _handleCheckOut(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Riwayat Absensi',
                          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 12),
                        if (history.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text('Belum ada riwayat absensi', style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey)),
                            ),
                          )
                        else
                          ...history.map((item) => _buildHistoryCard(item)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
      decoration: const BoxDecoration(
        gradient: AppColors.gradientPurple,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat datang 👋', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white.withOpacity(0.8))),
                Text('Karyawan', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool enabled,
    required bool loading,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 90,
      child: ElevatedButton(
        onPressed: enabled && !loading ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : AppColors.primaryLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: enabled ? Colors.white : AppColors.textGrey, size: 26),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.plusJakartaSans(color: enabled ? Colors.white : AppColors.textGrey, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(dynamic item) {
    Color statusColor = item.status == 'tepat_waktu' ? AppColors.success : item.status == 'telat' ? AppColors.warning : AppColors.danger;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.date, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                Text('Masuk: ${item.checkInTime ?? '-'}  •  Pulang: ${item.checkOutTime ?? '-'}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(item.status.replaceAll('_', ' '), style: GoogleFonts.plusJakartaSans(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}