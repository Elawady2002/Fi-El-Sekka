import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server failure - backend errors
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Authentication failure - auth related errors
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Network failure - connection issues
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// Validation failure - input validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Cache failure - local storage errors
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Unknown failure - unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});
}
