abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException()
    : super('You are offline. Check your connection and try again.');
}

class TimeoutException extends AppException {
  const TimeoutException()
    : super('The request took too long. Please try again.');
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'Something went wrong on the server.',
  ]);
}

class InvalidResponseException extends AppException {
  const InvalidResponseException()
    : super('We received an invalid response. Please try again.');
}

class UnknownException extends AppException {
  const UnknownException()
    : super('Something unexpected happened. Please try again.');
}

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.exception);

  final AppException exception;
}
