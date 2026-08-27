import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../../domain/entities/attendance_recap.dart';
import '../cubit/attendance_recap_cubit.dart';
import '../cubit/attendance_recap_state.dart';
import 'attendance_detail_screen.dart';

class AttendanceRecapScreen extends StatelessWidget {
  const AttendanceRecapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BlocProvider(
      create: (_) =>
          getIt<AttendanceRecapCubit>()
            ..loadAttendances(month: now.month, year: now.year),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Rekap Absensi',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<AttendanceRecapCubit, AttendanceRecapState>(
          builder: (context, state) {
            if (state is AttendanceRecapLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is AttendanceRecapFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey),
                ),
              );
            }

            if (state is AttendanceRecapLoaded) {
              if (state.attendances.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada data absensi',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textGrey,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => context
                    .read<AttendanceRecapCubit>()
                    .loadAttendances(month: now.month, year: now.year),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.attendances.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = state.attendances[index];
                    return _AttendanceTile(item: item);
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final AttendanceRecap item;
  const _AttendanceTile({required this.item});

  Color _statusColor() {
    switch (item.status.toLowerCase()) {
      case 'hadir':
        return AppColors.success;
      case 'telat':
        return AppColors.warning;
      case 'izin':
      case 'cuti':
        return Colors.blueGrey;
      default:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AttendanceDetailScreen(attendance: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: item.checkInPhoto != null
                  ? NetworkImage(item.checkInPhoto!)
                  : null,
              child: item.checkInPhoto == null
                  ? const Icon(Icons.person, color: AppColors.primary)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.userName,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${item.date}  •  ${item.checkInTime ?? '-'} - ${item.checkOutTime ?? '-'}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.status,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _statusColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
