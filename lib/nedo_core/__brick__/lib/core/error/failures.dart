import 'package:equatable/equatable.dart';
import 'exceptions.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? code;
  const ServerFailure(super.message, {this.code});
  
  @override
  List<Object?> get props => [message, code];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

class NetworkFailure extends Failure {
  final NetworkException exception;

  NetworkFailure(this.exception)
      : super(exception.message ?? 'an unknown error occurred');

  @override
  List<Object?> get props => [message, exception];
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message);
}

class DependencyFailure extends Failure {
  const DependencyFailure(super.message);
}

class NullFailure extends Failure {
  const NullFailure(super.message);
}