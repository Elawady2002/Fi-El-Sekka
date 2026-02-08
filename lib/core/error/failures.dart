import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final dynamic error;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.error,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, error, stackTrace];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Server failure - backend errors
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.error,
    super.stackTrace,
  });
}

/// Authentication failure - auth related errors
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.error,
    super.stackTrace,
  });
}

/// Network failure - connection issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code,
    super.error,
    super.stackTrace,
  });
}

/// Validation failure - input validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.error,
    super.stackTrace,
  });
}

/// Cache failure - local storage errors
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.error,
    super.stackTrace,
  });
}

/// Unknown failure - unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.error,
    super.stackTrace,
  });
}
