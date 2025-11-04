import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

/// Error widget with retry functionality
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: AppColors.error.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: 'Please check your internet connection and try again.',
      onRetry: onRetry,
      icon: Icons.wifi_off,
    );
  }
}

/// Offline indicator widget
class OfflineIndicatorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const OfflineIndicatorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.warning.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              customMessage ?? 'You are offline. Showing cached data.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppColors.warning,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Stale data indicator widget
class StaleDataIndicatorWidget extends StatelessWidget {
  final VoidCallback? onRefresh;
  final String? lastUpdated;

  const StaleDataIndicatorWidget({
    super.key,
    this.onRefresh,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.grey100.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: AppColors.grey600,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              lastUpdated != null 
                ? 'Last updated: $lastUpdated'
                : 'Data may be outdated',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.grey600,
                fontSize: 11,
              ),
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRefresh,
              child: Icon(
                Icons.refresh,
                color: AppColors.grey600,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Generic server error widget
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final int? statusCode;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.statusCode,
  });

  @override
  Widget build(BuildContext context) {
    String message = 'Server error occurred. Please try again later.';
    
    if (statusCode != null) {
      message = switch (statusCode!) {
        404 => 'The requested data was not found.',
        500 => 'Internal server error. Please try again later.',
        503 => 'Service temporarily unavailable. Please try again later.',
        _ => 'Server error ($statusCode). Please try again later.',
      };
    }

    return AppErrorWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.error_outline,
    );
  }
}

/// Data loading timeout error widget
class TimeoutErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const TimeoutErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: 'Request timed out. Please check your connection and try again.',
      onRetry: onRetry,
      icon: Icons.timer_off,
    );
  }
}

/// Authentication error widget
class AuthErrorWidget extends StatelessWidget {
  final VoidCallback? onLogin;

  const AuthErrorWidget({
    super.key,
    this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: 'You need to log in to access this content.',
      onRetry: onLogin,
      icon: Icons.lock_outline,
    );
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
