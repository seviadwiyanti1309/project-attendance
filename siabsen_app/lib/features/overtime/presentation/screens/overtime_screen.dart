import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../cubit/overtime_cubit.dart';
import '../cubit/overtime_state.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({super.key});

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final OvertimeCubit _cubit;

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cubit = getIt<OvertimeCubit>()..loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cubit.close();
    super.dispose();
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  void _submit() {
    if (_selectedDate == null || _startTime == null || _endTime == null || _reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data dulu'), backgroundColor: AppColors.danger),
      );
      return;
    }

    _cubit.submit(
      date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      startTime: _formatTime(_startTime),
      endTime: _formatTime(_endTime),
      reason: _reasonController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text('Pengajuan Lembur',
              style: GoogleFonts.plusJakartaSans(color: AppColors.textDark, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: AppColors.textDark),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textGrey,
            indicatorColor: AppColors.primary,
            tabs: const [Tab(text: 'Ajukan'), Tab(text: 'Riwayat')],
          ),
        ),
        body: BlocConsumer<OvertimeCubit, OvertimeState>(
          listener: (context, state) {
            if (state is OvertimeSubmitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengajuan lembur terkirim'), backgroundColor: AppColors.success),
              );
              setState(() {
                _selectedDate = null;
                _startTime = null;
                _endTime = null;
                _reasonController.clear();
              });
              _tabController.animateTo(1);
            } else if (state is OvertimeFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.danger),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is OvertimeLoading;
            return TabBarView(
              controller: _tabController,
              children: [
                _buildForm(isLoading),
                _buildHistory(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Tanggal Lembur'),
          _pickerTile(
            icon: Icons.calendar_today_rounded,
            value: _selectedDate == null ? 'Pilih tanggal' : DateFormat('dd MMMM yyyy').format(_selectedDate!),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now(),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
          ),
          const SizedBox(height: 16),
          _fieldLabel('Jam Mulai'),
          _pickerTile(
            icon: Icons.access_time_rounded,
            value: _startTime == null ? 'Pilih jam mulai' : _startTime!.format(context),
            onTap: () async {
              final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
              if (time != null) setState(() => _startTime = time);
            },
          ),
          const SizedBox(height: 16),
          _fieldLabel('Jam Selesai'),
          _pickerTile(
            icon: Icons.access_time_filled_rounded,
            value: _endTime == null ? 'Pilih jam selesai' : _endTime!.format(context),
            onTap: () async {
              final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
              if (time != null) setState(() => _endTime = time);
            },
          ),
          const SizedBox(height: 16),
          _fieldLabel('Alasan Lembur'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Contoh: Menyelesaikan laporan bulanan',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : Text('Kirim Pengajuan',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textGrey)),
      );

  Widget _pickerTile({required IconData icon, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(value, style: GoogleFonts.plusJakartaSans(color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(OvertimeState state) {
    if (state is OvertimeLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state is OvertimeHistoryLoaded) {
      if (state.items.isEmpty) {
        return Center(child: Text('Belum ada pengajuan', style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey)));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final item = state.items[index];
          Color statusColor = item.status == 'approved'
              ? AppColors.success
              : item.status == 'rejected'
                  ? AppColors.danger
                  : AppColors.warning;
          String statusLabel = item.status == 'approved'
              ? 'Disetujui'
              : item.status == 'rejected'
                  ? 'Ditolak'
                  : 'Menunggu';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.date, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(statusLabel, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${item.startTime.substring(0, 5)} - ${item.endTime.substring(0, 5)} (${(item.durationMinutes / 60).toStringAsFixed(1)} jam)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textGrey)),
                const SizedBox(height: 4),
                Text(item.reason, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textDark)),
              ],
            ),
          );
        },
      );
    }
    if (state is OvertimeFailure) {
      return Center(child: Text(state.message, style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey)));
    }
    return const SizedBox();
  }
}