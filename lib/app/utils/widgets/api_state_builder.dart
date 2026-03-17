import 'package:flutter/material.dart';
import '../../services/network/response/api_response.dart';
import '../../theme/app_colors.dart';

class ApiStateBuilder<T> extends StatelessWidget {
  final ApiResponse<T> response;
  final Widget Function(T data) builder;
  final Widget? loadingWidget;
  final Widget? idleWidget;
  final VoidCallback? onRetry;

  const ApiStateBuilder({
    super.key,
    required this.response,
    required this.builder,
    this.loadingWidget,
    this.idleWidget,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (response.status) {
      case ApiStatus.idle:
        return idleWidget ?? const SizedBox.shrink();

      case ApiStatus.loading:
        return loadingWidget ??
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );

      case ApiStatus.success:
        if (response.data == null) return const SizedBox.shrink();
        return builder(response.data as T);

      case ApiStatus.noInternet:
        return _ErrorView(
          icon: Icons.wifi_off,
          color: AppColors.errorNoInternet,
          title: 'No Internet',
          message: response.message ?? 'Please check your connection.',
          onRetry: onRetry,
        );

      case ApiStatus.timeout:
        return _ErrorView(
          icon: Icons.timer_off,
          color: AppColors.errorTimeout,
          title: 'Request Timeout',
          message: response.message ?? 'Please try again.',
          onRetry: onRetry,
        );

      case ApiStatus.unauthorized:
        return _ErrorView(
          icon: Icons.lock_outline,
          color: AppColors.errorUnauthorized,
          title: 'Unauthorized',
          message: response.message ?? 'Session expired.',
          onRetry: onRetry,
        );

      case ApiStatus.forbidden:
        return _ErrorView(
          icon: Icons.block,
          color: AppColors.errorForbidden,
          title: 'Access Denied',
          message: response.message ?? 'You do not have permission.',
          onRetry: onRetry,
        );

      case ApiStatus.serverError:
        return _ErrorView(
          icon: Icons.cloud_off,
          color: AppColors.errorServer,
          title: 'Server Error',
          message: response.message ?? 'Please try again later.',
          onRetry: onRetry,
        );

      default:
        return _ErrorView(
          icon: Icons.error_outline,
          color: AppColors.errorTimeout,
          title: 'Something went wrong',
          message: response.message ?? 'Please try again.',
          onRetry: onRetry,
        );
    }
  }
}

class _ErrorView extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const _ErrorView({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 64),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.gray)),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
