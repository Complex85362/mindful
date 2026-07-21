import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

/// The ONLY class in the auth feature that directly calls Firebase SDK
/// methods. Notice this class has no concept of Failure or Result -- it just
/// does the raw work and lets exceptions propagate naturally. Translating
/// those exceptions into domain Failures is the repository's job, one layer
/// out. Keeping that translation out of here means this class stays a thin,
/// honest wrapper around "what Firebase actually does."
class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleSignInInitialized = false;
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
  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await _googleSignIn.initialize(
      serverClientId: '669086846794-bndm1figls8fpfmp4g92rvlcp0d16dfr.apps.googleusercontent.com',
    );
    _googleSignInInitialized = true;
  }
  Future<UserModel> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    // Opens the account picker / Credential Manager sheet. Throws a
    // GoogleSignInException (not a plain Exception) if the user cancels --
    // caught one layer out, in the repository.
    final googleUser = await _googleSignIn.authenticate();

    // NOTE: in v7, .authentication is a synchronous getter, not an async
    // method -- no `await` here.
    final googleAuth = googleUser.authentication;

    final credential = firebase_auth.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return UserModel.fromFirebaseUser(userCredential.user!);
  }
  Future<UserModel> updateProfile({String? displayName, String? avatarUrl}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No signed-in user to update.',
      );
    }
    if (displayName != null) await user.updateDisplayName(displayName);
    if (avatarUrl != null) await user.updatePhotoURL(avatarUrl);
    await user.reload();
    return UserModel.fromFirebaseUser(_firebaseAuth.currentUser!);
  }
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if (_googleSignInInitialized) {
      await _googleSignIn.signOut();
    }
  }
}