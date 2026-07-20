/// Base class for all domain-level failures.
///
/// Every concrete Failure subclass lives in the domain layer and describes
/// *what* went wrong in terms the UI can react to -- never *how* (no
/// Firebase exception types, no HTTP status codes leak past the data layer).
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
