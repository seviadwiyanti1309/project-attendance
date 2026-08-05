import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late final AdminCubit _adminCubit;

  @override
  void initState() {
    super.initState();
    _adminCubit = getIt<AdminCubit>();
    _adminCubit.loadEmployees();
  }

  @override
  void dispose() {
    _adminCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _adminCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text('Kelola Karyawan',
              style: GoogleFonts.plusJakartaSans(color: AppColors.textDark, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: AppColors.textDark),
        ),
        body: BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {
            if (state is EmployeeAddSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Karyawan berhasil ditambahkan'), backgroundColor: AppColors.success),
              );
            } else if (state is AdminFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.danger),
              );
            }
          },
          builder: (context, state) {
            if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (state is EmployeesLoaded) {
              if (state.employees.isEmpty) {
                return Center(
                    child:
                        Text('Belum ada karyawan', style: GoogleFonts.plusJakartaSans(color: AppColors.textGrey)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.employees.length,
                itemBuilder: (context, index) {
  final emp = state.employees[index];
  return Dismissible(
    key: Key(emp.id.toString()),
    direction: DismissDirection.endToStart,
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete_rounded, color: Colors.white),
    ),
    confirmDismiss: (direction) async {
      return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Hapus Karyawan'),
          content: Text('Yakin mau hapus ${emp.name}?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
          ],
        ),
      );
    },
    onDismissed: (direction) {
      _adminCubit.deleteEmployee(emp.id);
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryLight,
            child: Text(emp.name[0].toUpperCase(),
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.name,
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                Text(emp.position ?? emp.email,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => _showAddEmployeeSheet(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddEmployeeSheet(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final positionController = TextEditingController();
    final salaryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tambah Karyawan', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama')),
                  TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                  TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                  TextField(controller: positionController, decoration: const InputDecoration(labelText: 'Posisi (opsional)')),
                  TextField(controller: salaryController, decoration: const InputDecoration(labelText: 'Gaji Pokok (opsional)'), keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      onPressed: () {
                        _adminCubit.addEmployee(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          position: positionController.text.trim().isEmpty ? null : positionController.text.trim(),
                          baseSalary: double.tryParse(salaryController.text.trim()),
                        );
                        Navigator.pop(sheetContext);
                      },
                      child: Text('Simpan', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}