import 'package:core/src/features/auth/domain/repositories/auth_repository.dart';
import '../../../../common/result.dart';
import '../entities/user.dart';
class SignUpWithEmail {
  final AuthRepository repository;

  const SignUpWithEmail(this.repository);

  Future<Result<User>> call({
    required String email,
    required String password,
  }){
    return repository.signUpWithEmail(email: email, password: password);
  }

}