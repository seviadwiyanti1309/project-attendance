import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;
  GetProfileUsecase(this.repository);
  Future<ProfileEntity> call() => repository.getProfile();
}