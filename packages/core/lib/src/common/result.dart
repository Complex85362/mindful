import 'failure.dart';

/// A minimal Either-style result type: a use case either Succeeds with a
/// value of type [T], or Fails with a [Failure]. Never both, never neither.
///
/// Why not just throw exceptions? Because exceptions crossing from the data
/// layer (Firebase) into the domain layer would mean the domain now depends
/// on Firebase's exception types -- exactly the dependency direction clean
/// architecture forbids. Wrapping every data-layer call in a Result lets the
/// repository implementation catch Firebase-specific exceptions and
/// translate them into domain Failures, right at the boundary.
sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Failure failure) = FailureResult<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  /// Pattern-match style helper: run [onSuccess] or [onFailure] depending on
  /// which variant this is, and return whatever they return.
  R fold<R>(R Function(Failure failure) onFailure, R Function(T value) onSuccess) {
    return switch (this) {
      Success<T>(value: final v) => onSuccess(v),
      FailureResult<T>(failure: final f) => onFailure(f),
    };
  }
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}
