import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/attendance_recap.dart';

class AttendanceDetailScreen extends StatelessWidget {
  final AttendanceRecap attendance;
  const AttendanceDetailScreen({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Absensi',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendance.userName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (attendance.userPosition != null)
                  Text(
                    attendance.userPosition!,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textGrey,
                    ),
                  ),
                const Divider(height: 24),
                _row('Tanggal', attendance.date),
                _row('Status', attendance.status),
                _row('Lembur', '${attendance.overtimeMinutes} menit'),
                if (attendance.reason != null)
                  _row('Keterangan', attendance.reason!),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sessionCard(
            title: 'Check In',
            time: attendance.checkInTime,
            photo: attendance.checkInPhoto,
            address: attendance.checkInAddress,
          ),
          const SizedBox(height: 16),
          _sessionCard(
            title: 'Check Out',
            time: attendance.checkOutTime,
            photo: attendance.checkOutPhoto,
            address: attendance.checkOutAddress,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _sessionCard({
    required String title,
    String? time,
    String? photo,
    String? address,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Jam: ${time ?? '-'}',
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
          ),
          if (address != null)
            Text(
              'Lokasi: $address',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          if (photo != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photo,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
