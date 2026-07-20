/// Domain entity representing a signed-in user.
///
/// This class intentionally has NO dependency on Firebase, Flutter, or any
/// other framework. It is pure Dart. This is the innermost ring of clean
/// architecture -- nothing here should ever need to change because we
/// swapped Firebase for something else, or because a widget's UI changed.
class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime createdAt;

  const User({
    required this.uid,
    required this.email,
    required this.createdAt,
    this.displayName,
    this.avatarUrl,
  });

  /// Value equality -- two User instances with the same fields are equal
  /// regardless of object identity. This lets Provider/ChangeNotifier layers
  /// above correctly detect "did the user actually change".
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName &&
          avatarUrl == other.avatarUrl &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      avatarUrl.hashCode ^
      createdAt.hashCode;

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
