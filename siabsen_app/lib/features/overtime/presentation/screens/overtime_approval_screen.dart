import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../cubit/overtime_approval_cubit.dart';
import '../cubit/overtime_approval_state.dart';

class OvertimeApprovalScreen extends StatefulWidget {
  const OvertimeApprovalScreen({super.key});

  @override
  State<OvertimeApprovalScreen> createState() => _OvertimeApprovalScreenState();
}

class _OvertimeApprovalScreenState extends State<OvertimeApprovalScreen> {
  late final OvertimeApprovalCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OvertimeApprovalCubit>()..loadPending();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
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
          title: Text('Persetujuan Lembur',
              style: GoogleFonts.plusJakartaSans(color: AppColors.textDark, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: AppColors.textDark),
        ),
        body: BlocConsumer<OvertimeApprovalCubit, OvertimeApprovalState>(
          listener: (context, state) {
            if (state is ApprovalFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.danger),
              );
            }
          },
          builder: (context, state) {
            if (state is ApprovalLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (state is PendingLoaded) {
              if (state.items.isEmpty) {
                return Center(
                    child: Text('Tidak ada pengajuan pending',
                        style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
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
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primaryLight,
                              child: Text((item.employeeName ?? '?')[0].toUpperCase(),
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.employeeName ?? '-',
                                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  Text(item.date, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('${item.startTime.substring(0, 5)} - ${item.endTime.substring(0, 5)} (${(item.durationMinutes / 60).toStringAsFixed(1)} jam)',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textGrey)),
                        const SizedBox(height: 4),
                        Text(item.reason, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textDark)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _cubit.reject(item.id),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.danger),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Tolak', style: GoogleFonts.plusJakartaSans(color: AppColors.danger, fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _cubit.approve(item.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Setujui', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            if (state is ApprovalFailure) {
              return Center(child: Text(state.message, style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}