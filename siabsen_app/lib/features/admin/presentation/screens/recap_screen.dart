import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';

class RecapScreen extends StatefulWidget {
  const RecapScreen({super.key});

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminCubit>()..loadMonthlyRecap(month: _selectedMonth, year: _selectedYear),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text('Rekap Gaji & Lembur', style: GoogleFonts.plusJakartaSans(color: AppColors.textDark, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: AppColors.textDark),
        ),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _selectedMonth,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.cardWhite,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(_months[i]))),
                          onChanged: (val) {
                            setState(() => _selectedMonth = val!);
                            context.read<AdminCubit>().loadMonthlyRecap(month: _selectedMonth, year: _selectedYear);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _selectedYear,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.cardWhite,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          items: List.generate(3, (i) {
                            final year = DateTime.now().year - 1 + i;
                            return DropdownMenuItem(value: year, child: Text('$year'));
                          }),
                          onChanged: (val) {
                            setState(() => _selectedYear = val!);
                            context.read<AdminCubit>().loadMonthlyRecap(month: _selectedMonth, year: _selectedYear);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildContent(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(AdminState state) {
    if (state is AdminLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state is RecapLoaded) {
      if (state.recap.isEmpty) {
        return Center(child: Text('Belum ada data', style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey)));
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        itemCount: state.recap.length,
        itemBuilder: (context, index) {
          final item = state.recap[index];
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
                Text(item.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _miniStat('Hadir', '${item.totalHadir} hari'),
                    _miniStat('Telat', '${item.totalTelat} hari'),
                    _miniStat('Lembur', '${(item.totalOvertimeMinutes / 60).toStringAsFixed(1)} jam'),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Estimasi Total Gaji', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textGrey)),
                    Text(
                      'Rp ${item.estimatedTotalSalary.toStringAsFixed(0)}',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
    if (state is AdminFailure) {
      return Center(child: Text(state.message, style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey)));
    }
    return const SizedBox();
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.textDark)),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textGrey)),
      ],
    );
  }
}