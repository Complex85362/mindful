import 'package:core/src/features/auth/domain/repositories/auth_repository.dart';
import '../../../../common/result.dart';
class SignOut {

  final AuthRepository repository;
  const SignOut(this.repository);

  Future<Result<void>> call(){
    return repository.signOut();
  }
}