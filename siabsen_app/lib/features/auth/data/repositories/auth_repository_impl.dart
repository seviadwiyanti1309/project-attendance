import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/token_manager.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  AuthRepositoryImpl(this.apiClient, this.tokenManager);

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await apiClient.post(
      ApiConstants.login,
      {'email': email, 'password': password},
      withAuth: false,
    );

    final user = UserModel.fromJson(response['user']);
    await tokenManager.saveToken(response['token']);
    await tokenManager.saveRole(user.role);

    return user;
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiConstants.logout, {});
    await tokenManager.clear();
  }
}