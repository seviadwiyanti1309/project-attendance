import '../../../../core/network/api_client.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient apiClient;
  ProfileRepositoryImpl(this.apiClient);

  @override
  Future<ProfileEntity> getProfile() async {
    final response = await apiClient.get('/user');
    return ProfileModel.fromJson(response);
  }
}