import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('fold calls onSuccess for a Success result', () {
      const result = Result<int>.success(42);

      final output = result.fold(
        (failure) => 'failed: ${failure.message}',
        (value) => 'succeeded: $value',
      );

      expect(output, 'succeeded: 42');
    });

    test('fold calls onFailure for a FailureResult', () {
      const result = Result<int>.failure(AuthFailure('bad password'));

      final output = result.fold(
        (failure) => 'failed: ${failure.message}',
        (value) => 'succeeded: $value',
      );

      expect(output, 'failed: bad password');
    });
  });

  group('User', () {
    test('two Users with identical fields are equal', () {
      final createdAt = DateTime(2026, 1, 1);

      final userA = User(uid: 'abc123', email: 'a@b.com', createdAt: createdAt);
      final userB = User(uid: 'abc123', email: 'a@b.com', createdAt: createdAt);

      expect(userA, equals(userB));
    });

    test('copyWith changes only the specified field', () {
      final original = User(
        uid: 'abc123',
        email: 'a@b.com',
        createdAt: DateTime(2026, 1, 1),
        displayName: 'Old Name',
      );

      final updated = original.copyWith(displayName: 'New Name');

      expect(updated.displayName, 'New Name');
      expect(updated.uid, original.uid);
      expect(updated.email, original.email);
    });
  });
}
