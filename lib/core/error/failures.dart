abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  final dynamic validationErrors;

  const  ValidationFailure({
    required String message,
    this.validationErrors,
  }) : super(message:  message);

  @override
  List<Object?> get props => [message, validationErrors];
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({required String message}) : super(message: message);
}
