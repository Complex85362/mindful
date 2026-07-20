import 'package:core/src/features/auth/domain/repositories/auth_repository.dart';
import '../../../../common/result.dart';
import '../entities/user.dart';
class SignInWithGoogle {
  final AuthRepository repository;

  const SignInWithGoogle(this.repository);
  

  Future<Result<User>> call(){
    return repository.signInWithGoogle();
  }
}