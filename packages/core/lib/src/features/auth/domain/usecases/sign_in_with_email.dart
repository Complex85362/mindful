import 'package:core/src/features/auth/domain/repositories/auth_repository.dart';
import '../../../../common/result.dart';
import '../entities/user.dart';

class SignInWithEmail {
  final AuthRepository repository;

  const SignInWithEmail(this.repository);

  Future<Result<User>> call({
    required String email,
    required String password,
}) {
    return repository.signInWithEmail(email: email, password: password);
  }
}