import 'package:get_it/get_it.dart';
import 'package:siabsen_app/features/admin/domain/usecases/get_monthly_recap_usecase.dart';
import 'core/network/api_client.dart';
import 'core/utils/token_manager.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/attendance/domain/repositories/attendance_repository.dart';
import 'features/attendance/domain/usecases/check_in_usecase.dart';
import 'features/attendance/domain/usecases/check_out_usecase.dart';
import 'features/attendance/domain/usecases/get_history_usecase.dart';
import 'features/attendance/presentation/cubit/attendance_cubit.dart';

import 'features/admin/data/repositories/admin_repository_impl.dart';
import 'features/admin/domain/repositories/admin_repository.dart';
import 'features/admin/domain/usecases/get_dashboard_summary_usecase.dart';
import 'features/admin/domain/usecases/get_employees_usecase.dart';
import 'features/admin/domain/usecases/add_employee_usecase.dart';
import 'features/admin/presentation/cubit/admin_cubit.dart';

final getIt = GetIt.instance;

void setupInjection() {
  // Core
  getIt.registerLazySingleton(() => TokenManager());
  getIt.registerLazySingleton(() => ApiClient(getIt()));

  // Auth feature
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton(() => LoginUsecase(getIt()));
  getIt.registerFactory(() => AuthCubit(getIt()));

  // Attendance feature
  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => CheckInUsecase(getIt()));
  getIt.registerLazySingleton(() => CheckOutUsecase(getIt()));
  getIt.registerLazySingleton(() => GetHistoryUsecase(getIt()));
  getIt.registerFactory(() => AttendanceCubit(getIt(), getIt(), getIt()));

  // Admin feature
  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetDashboardSummaryUsecase(getIt()));
  getIt.registerLazySingleton(() => GetEmployeesUsecase(getIt()));
  getIt.registerLazySingleton(() => AddEmployeeUsecase(getIt()));
  getIt.registerLazySingleton(() => GetMonthlyRecapUsecase(getIt()));
  getIt.registerFactory(() => AdminCubit(getIt(), getIt(), getIt(), getIt()));
}