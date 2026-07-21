import '../entities/user.dart';
import '../../../../common/result.dart';

///The contract for authentication, as seen by the domain layer.
///This is the interface that domain layer use cases depends on, never on the firebase Auth directyly
abstract class AuthRepository{
  Stream<User?> get authStateChanges;

  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
});

  Future<Result<User>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
});

  Future<Result<User>> signInWithGoogle();

  Future<Result<void>> signOut();


}