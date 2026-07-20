import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/user.dart';

class UserModel extends User{
  const UserModel({
    required super.uid,
    required super.email,
    required super.createdAt,
    super.displayName,
    super.avatarUrl,
});

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser){
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      avatarUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }
}