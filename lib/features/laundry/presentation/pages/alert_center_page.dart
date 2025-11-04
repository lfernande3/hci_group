import 'package:flutter/material.dart';
import '../../data/models/laundry_alert.dart';

/// Alert Center page showing list of active laundry alerts
class AlertCenterPage extends StatefulWidget {
  const AlertCenterPage({super.key});

  @override
  State<AlertCenterPage> createState() => _AlertCenterPageState();
}

class _AlertCenterPageState extends State<AlertCenterPage> {
  final LaundryAlertManager _alertManager = LaundryAlertManager();

  @override
  void initState() {
    super.initState();
    _alertManager.addListener(_onAlertsChanged);
  }

  @override
  void dispose() {
    _alertManager.removeListener(_onAlertsChanged);
    super.dispose();
  }

  void _onAlertsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<LaundryAlert> get _activeAlerts => _alertManager.alerts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Center'),
        actions: [
          if (_activeAlerts.isNotEmpty)
            TextButton.icon(
              onPressed: _showClearAllDialog,
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear All'),
            ),
        ],
      ),
      body: _activeAlerts.isEmpty
          ? _buildEmptyState(theme, colorScheme)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _activeAlerts.length,
              itemBuilder: (context, index) {
                final alert = _activeAlerts[index];
                return _AlertCard(
                  alert: alert,
                  onCancel: () => _cancelAlert(alert.id),
                  onEdit: () => _editAlert(alert),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    final textTheme = theme.textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Alerts',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set alerts from machine details to get notified',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _cancelAlert(String alertId) {
    _alertManager.removeAlert(alertId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alert cancelled'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editAlert(LaundryAlert alert) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Grace Period'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set grace period reminder (minutes after cycle ends)',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _GracePeriodButton(
                  minutes: 5,
                  current: alert.gracePeriodMinutes,
                  onSelect: (minutes) {
                    final updatedAlert = LaundryAlert(
                      id: alert.id,
                      stackId: alert.stackId,
                      stackLabel: alert.stackLabel,
                      roomId: alert.roomId,
                      roomName: alert.roomName,
                      machineType: alert.machineType,
                      type: alert.type,
                      createdAt: alert.createdAt,
                      gracePeriodMinutes: minutes,
                    );
                    _alertManager.updateAlert(updatedAlert);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Grace period updated'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _GracePeriodButton(
                  minutes: 10,
                  current: alert.gracePeriodMinutes,
                  onSelect: (minutes) {
                    final updatedAlert = LaundryAlert(
                      id: alert.id,
                      stackId: alert.stackId,
                      stackLabel: alert.stackLabel,
                      roomId: alert.roomId,
                      roomName: alert.roomName,
                      machineType: alert.machineType,
                      type: alert.type,
                      createdAt: alert.createdAt,
                      gracePeriodMinutes: minutes,
                    );
                    _alertManager.updateAlert(updatedAlert);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Grace period updated'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Alerts'),
        content: const Text('Are you sure you want to cancel all active alerts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _alertManager.clearAll();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All alerts cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  // Getter for active alerts (for external access)
  List<LaundryAlert> get activeAlerts => List.unmodifiable(_activeAlerts);
}

/// Global alert manager for demo (in production, use provider or state management)
class LaundryAlertManager {
  static final LaundryAlertManager _instance = LaundryAlertManager._internal();
  factory LaundryAlertManager() => _instance;
  LaundryAlertManager._internal();

  final List<LaundryAlert> _alerts = [];
  final List<VoidCallback> _listeners = [];

  List<LaundryAlert> get alerts => List.unmodifiable(_alerts);

  void addAlert(LaundryAlert alert) {
    _alerts.add(alert);
    _notifyListeners();
  }

  void removeAlert(String alertId) {
    _alerts.removeWhere((a) => a.id == alertId);
    _notifyListeners();
  }

  void updateAlert(LaundryAlert alert) {
    final index = _alerts.indexWhere((a) => a.id == alert.id);
    if (index != -1) {
      _alerts[index] = alert;
      _notifyListeners();
    }
  }

  void clearAll() {
    _alerts.clear();
    _notifyListeners();
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

/// Alert Card Widget
class _AlertCard extends StatelessWidget {
  final LaundryAlert alert;
  final VoidCallback onCancel;
  final VoidCallback onEdit;

  const _AlertCard({
    required this.alert,
    required this.onCancel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${alert.stackLabel} - ${alert.machineType}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        alert.roomName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onCancel,
                  tooltip: 'Cancel alert',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.typeDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (alert.gracePeriodMinutes != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Grace period: ${alert.gracePeriodMinutes} minutes',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Grace'),
                ),
                const Spacer(),
                Text(
                  _formatTimeAgo(alert.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Grace Period Button Widget
class _GracePeriodButton extends StatelessWidget {
  final int minutes;
  final int? current;
  final Function(int) onSelect;

  const _GracePeriodButton({
    required this.minutes,
    this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = current == minutes;

    return ElevatedButton(
      onPressed: () => onSelect(minutes),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceVariant,
        foregroundColor: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
      ),
      child: Text('${minutes}m'),
    );
  }
}

