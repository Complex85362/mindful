import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../models/user_model.dart';

/// The ONLY class in the auth feature that directly calls Firebase SDK
/// methods. Notice this class has no concept of Failure or Result -- it just
/// does the raw work and lets exceptions propagate naturally. Translating
/// those exceptions into domain Failures is the repository's job, one layer
/// out. Keeping that translation out of here means this class stays a thin,
/// honest wrapper around "what Firebase actually does."
class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user!);
  }

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user!;
    await firebaseUser.updateDisplayName(displayName);
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? email,
      displayName: displayName,
      avatarUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  Future<UserModel> signInWithGoogle() async {
    // Deferred to a dedicated feature branch -- google_sign_in's current API
    // needs platform-specific handling (web vs mobile) that deserves its
    // own focused pass rather than being rushed here.
    throw UnimplementedError('Google Sign-In not yet implemented');
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}