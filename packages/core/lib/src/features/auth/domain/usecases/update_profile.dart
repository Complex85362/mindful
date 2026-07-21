import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../common/result.dart';

class UpdateProfile {
  final AuthRepository repository;
  const UpdateProfile(this.repository);

  Future<Result<User>> call({
    required String uid,
    String? displayName,
    String? avatarUrl,
  }) {
    return repository.updateProfile(uid: uid, displayName: displayName, avatarUrl: avatarUrl);
  }
}