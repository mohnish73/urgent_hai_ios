import 'package:flutter/material.dart';
import '../../../core/storage/hive_service.dart';
import '../../../routes/app_router.dart';
import 'api_response.dart';

class GlobalErrorHandler {
  static void handle<T>(
    BuildContext context,
    ApiResponse<T> response, {
    VoidCallback? onRetry,
  }) {
    if (response.isSuccess) return;

    if (response.status == ApiStatus.unauthorized) {
      _handleUnauthorized(context);
      return;
    }

    _showErrorDialog(context, response, onRetry: onRetry);
  }

  static void _handleUnauthorized(BuildContext context) {
    HiveService.clearAll();
    AppRouter.router.go(AppRoutes.login);
  }

  static void _showErrorDialog<T>(
    BuildContext context,
    ApiResponse<T> response, {
    VoidCallback? onRetry,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ErrorBottomSheet(
        status: response.status,
        message: response.message ?? 'Something went wrong.',
        onRetry: onRetry,
      ),
    );
  }
}

class _ErrorBottomSheet extends StatelessWidget {
  final ApiStatus status;
  final String message;
  final VoidCallback? onRetry;

  const _ErrorBottomSheet({
    required this.status,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Icon(config.icon, color: config.color, size: 48),
          const SizedBox(height: 16),
          Text(config.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          if (onRetry != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onRetry!();
                },
                child: const Text('Retry'),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  _ErrorConfig _getConfig(ApiStatus status) {
    switch (status) {
      case ApiStatus.noInternet:
        return _ErrorConfig('No Internet', Icons.wifi_off, const Color(0xFF0284C7));
      case ApiStatus.timeout:
        return _ErrorConfig('Request Timeout', Icons.timer_off, const Color(0xFFD97706));
      case ApiStatus.unauthorized:
        return _ErrorConfig('Unauthorized', Icons.lock, const Color(0xFFDC2626));
      case ApiStatus.forbidden:
        return _ErrorConfig('Access Denied', Icons.block, const Color(0xFFEA580C));
      case ApiStatus.serverError:
        return _ErrorConfig('Server Error', Icons.cloud_off, const Color(0xFF7C3AED));
      default:
        return _ErrorConfig('Something went wrong', Icons.error_outline, const Color(0xFFD97706));
    }
  }
}

class _ErrorConfig {
  final String title;
  final IconData icon;
  final Color color;
  _ErrorConfig(this.title, this.icon, this.color);
}
