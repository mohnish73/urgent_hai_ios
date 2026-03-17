class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException() : super('No internet connection. Please check your network.');
}

class RequestTimeoutException extends AppException {
  const RequestTimeoutException() : super('Request timed out. Please try again.');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('Session expired. Please login again.');
}

class ForbiddenException extends AppException {
  const ForbiddenException() : super('You do not have permission to perform this action.');
}

class ServerException extends AppException {
  const ServerException() : super('Server error. Please try again later.');
}

class FetchDataException extends AppException {
  const FetchDataException([String msg = 'Error fetching data.']) : super(msg);
}
