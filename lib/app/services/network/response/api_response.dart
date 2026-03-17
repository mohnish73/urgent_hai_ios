enum ApiStatus {
  idle,
  loading,
  success,
  error,
  noInternet,
  unauthorized,
  forbidden,
  serverError,
  timeout,
}

class ApiResponse<T> {
  final ApiStatus status;
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse._({
    required this.status,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.idle() => const ApiResponse._(status: ApiStatus.idle);

  factory ApiResponse.loading() => const ApiResponse._(status: ApiStatus.loading);

  factory ApiResponse.success(T data, {int? statusCode}) => ApiResponse._(
        status: ApiStatus.success,
        data: data,
        statusCode: statusCode,
      );

  factory ApiResponse.error(String message, {int? statusCode}) => ApiResponse._(
        status: ApiStatus.error,
        message: message,
        statusCode: statusCode,
      );

  factory ApiResponse.noInternet() => const ApiResponse._(
        status: ApiStatus.noInternet,
        message: 'No internet connection. Please check your network.',
      );

  factory ApiResponse.unauthorized() => const ApiResponse._(
        status: ApiStatus.unauthorized,
        message: 'Session expired. Please login again.',
        statusCode: 401,
      );

  factory ApiResponse.forbidden() => const ApiResponse._(
        status: ApiStatus.forbidden,
        message: 'You do not have permission to perform this action.',
        statusCode: 403,
      );

  factory ApiResponse.serverError({String? message}) => ApiResponse._(
        status: ApiStatus.serverError,
        message: message ?? 'Server error. Please try again later.',
        statusCode: 500,
      );

  factory ApiResponse.timeout() => const ApiResponse._(
        status: ApiStatus.timeout,
        message: 'Request timed out. Please try again.',
      );

  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status != ApiStatus.success && status != ApiStatus.loading && status != ApiStatus.idle;
}
