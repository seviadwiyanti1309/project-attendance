import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../domain/entities/attendance_entity.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  bool _isToday(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      final now = DateTime.now();
      return parsed.year == now.year && parsed.month == now.month && parsed.day == now.day;
    } catch (_) {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      return dateStr.startsWith(todayStr);
    }
  }

  Future<void> _handleCheckIn(BuildContext context) async {
    final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (photo != null && context.mounted) {
      context.read<AttendanceCubit>().checkIn(photo.path);
    }
  }

  void _showLeaveDialog(BuildContext context) {
    String selectedType = 'izin';
    final reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ajukan Izin/Sakit', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'izin',
                            groupValue: selectedType,
                            title: const Text('Izin'),
                            onChanged: (val) => setSheetState(() => selectedType = val!),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'sakit',
                            groupValue: selectedType,
                            title: const Text('Sakit'),
                            onChanged: (val) => setSheetState(() => selectedType = val!),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: reasonController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Keterangan'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          if (reasonController.text.trim().isEmpty) return;
                          context.read<AttendanceCubit>().submitLeave(
                                type: selectedType,
                                reason: reasonController.text.trim(),
                              );
                          Navigator.pop(sheetContext);
                        },
                        child: Text('Kirim', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleCheckOut(BuildContext context) async {
    final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (photo != null && context.mounted) {
      context.read<AttendanceCubit>().checkOut(photo.path);
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin mau logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Keluar')),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await getIt<AuthRepository>().logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>()..loadHistory(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: () => _handleLogout(context),
            ),
          ],
        ),
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
  } else if (state is LeaveSubmitSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengajuan izin/sakit berhasil dikirim'), backgroundColor: AppColors.success),
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
            final history = state is HistoryLoaded ? state.items : <AttendanceEntity>[];
            final today = history.where((item) => _isToday(item.date)).firstOrNull;
            final isLeaveToday = today?.status == 'izin' || today?.status == 'sakit';

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
                                enabled: today?.checkInTime == null && !isLeaveToday,
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
                                enabled: today?.checkInTime != null && today?.checkOutTime == null && !isLeaveToday,
                                loading: isLoading,
                                onTap: () => _handleCheckOut(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: today == null ? () => _showLeaveDialog(context) : null,
                            icon: const Icon(Icons.event_busy_rounded, color: AppColors.primary),
                            label: Text('Ajukan Izin/Sakit', style: GoogleFonts.plusJakartaSans(color: AppColors.primary, fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
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
    Color statusColor = item.status == 'tepat_waktu' ? AppColors.success : item.status == 'telat' ? AppColors.warning : item.status == 'izin' || item.status == 'sakit' ? AppColors.primary : AppColors.danger;
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