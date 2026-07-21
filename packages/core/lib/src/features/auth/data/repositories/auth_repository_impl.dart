import 'package:core/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user.dart';
import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Stream<User?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
}) async{
    try{
      final user = await _dataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Result.success(user);
    }on firebase_auth.FirebaseAuthException catch(e){
      return Result.failure(_mapFirebaseAuthException(e));
    }catch (e){
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

@override
  Future<Result<User>> signUpWithEmail({
    required String email,
    required String password,
  required String displayName,
}) async{
    try{
      final user = await _dataSource.signUpWithEmail(
        email: email,
        password : password,
        displayName: displayName,
      );
      return Result.success(user);
    } on firebase_auth.FirebaseAuthException catch (e){
      return Result.failure(_mapFirebaseAuthException(e));
    } catch (e){
      return Result.failure(UnknownFailure(e.toString()));
    }
}

  @override
  Future<Result<User>> signInWithGoogle() async {
    try {
      final user = await _dataSource.signInWithGoogle();
      return Result.success(user);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Result.failure(AuthFailure('Sign-in cancelled.'));
      }
      return Result.failure(AuthFailure(e.description ?? 'Google sign-in failed.'));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }


  @override
  Future<Result<void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
  @override
  Future<Result<User>> updateProfile({
    required String uid,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final user = await _dataSource.updateProfile(
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
      return Result.success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
  Failure _mapFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const AuthFailure('Incorrect email or password.');
      case 'invalid-email':
        return const AuthFailure('That email address looks invalid.');
      case 'email-already-in-use':
        return const AuthFailure('An account with this email already exists.');
      case 'weak-password':
        return const AuthFailure('Password is too weak. Use at least 6 characters.');
      case 'user-disabled':
        return const AuthFailure('This account has been disabled.');
      case 'too-many-requests':
        return const AuthFailure('Too many attempts. Try again later.');
      case 'network-request-failed':
        return const NetworkFailure('No internet connection.');
      default:
        return AuthFailure(e.message ?? 'Authentication failed.');
    }
  }
}