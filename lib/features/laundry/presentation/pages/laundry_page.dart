import 'package:flutter/material.dart';
import '../../../../data/demo/laundry_data.dart';
import 'alert_center_page.dart';
import '../../data/models/laundry_alert.dart';

/// Laundry Management page with room selector and machine status
class LaundryPage extends StatefulWidget {
  const LaundryPage({super.key});

  @override
  State<LaundryPage> createState() => _LaundryPageState();
}

enum _MachineTypeFilter { all, washers, dryers, free }

class _LaundryPageState extends State<LaundryPage> {
  String? _selectedRoomId;
  _MachineTypeFilter _machineTypeFilter = _MachineTypeFilter.all;
  Set<String> _statusFilters = {}; // 'free', 'finishingSoon'
  final LaundryAlertManager _alertManager = LaundryAlertManager();

  @override
  void initState() {
    super.initState();
    // Default to first room
    if (halls.isNotEmpty) {
      _selectedRoomId = halls.first.id;
    }
    // Listen to alert changes to update badge
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Management'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                // Badge showing alert count
                if (_alertManager.alerts.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${_alertManager.alerts.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AlertCenterPage(),
                ),
              );
            },
            tooltip: 'Alert Center',
          ),
        ],
        // AppTheme automatically applied
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Laundry Room Selector (Chips)
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Laundry Room',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: halls.map((room) {
                    final isSelected = _selectedRoomId == room.id;
                    return FilterChip(
                      selected: isSelected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_laundry_service,
                            size: 18,
                            color: isSelected
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                room.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              Text(
                                room.location,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedRoomId = selected ? room.id : null;
                        });
                      },
                      selectedColor: colorScheme.secondaryContainer,
                      checkmarkColor: colorScheme.onSecondaryContainer,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Filter Section
          if (_selectedRoomId != null) ...[
            // Segmented Control for Machine Type
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SegmentedButton<_MachineTypeFilter>(
                segments: const [
                  ButtonSegment(
                    value: _MachineTypeFilter.all,
                    label: Text('All'),
                    icon: Icon(Icons.grid_view, size: 18),
                  ),
                  ButtonSegment(
                    value: _MachineTypeFilter.washers,
                    label: Text('Washers'),
                    icon: Icon(Icons.water_drop, size: 18),
                  ),
                  ButtonSegment(
                    value: _MachineTypeFilter.dryers,
                    label: Text('Dryers'),
                    icon: Icon(Icons.air, size: 18),
                  ),
                  ButtonSegment(
                    value: _MachineTypeFilter.free,
                    label: Text('Free'),
                    icon: Icon(Icons.check_circle, size: 18),
                  ),
                ],
                selected: {_machineTypeFilter},
                onSelectionChanged: (Set<_MachineTypeFilter> newSelection) {
                  setState(() {
                    _machineTypeFilter = newSelection.first;
                  });
                },
              ),
            ),
            // Filter Chips for Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    selected: _statusFilters.contains('free'),
                    label: const Text('Free'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _statusFilters.add('free');
                        } else {
                          _statusFilters.remove('free');
                        }
                      });
                    },
                  ),
                  FilterChip(
                    selected: _statusFilters.contains('finishingSoon'),
                    label: const Text('Finishing Soon'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _statusFilters.add('finishingSoon');
                        } else {
                          _statusFilters.remove('finishingSoon');
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          // Machine Stack Grid
          Expanded(
            child: _selectedRoomId == null
                ? Center(
                    child: Text(
                      'Please select a laundry room',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  )
                : _MachineStackGrid(
                    roomId: _selectedRoomId!,
                    machineTypeFilter: _machineTypeFilter,
                    statusFilters: _statusFilters,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Machine Stack Grid Widget
/// Displays machine stacks in a grid layout (Dryer atop Washer)
class _MachineStackGrid extends StatelessWidget {
  final String roomId;
  final _MachineTypeFilter machineTypeFilter;
  final Set<String> statusFilters;

  const _MachineStackGrid({
    required this.roomId,
    required this.machineTypeFilter,
    required this.statusFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    var roomMachines = getMachinesForRoom(roomId);

    // Apply machine type filter
    switch (machineTypeFilter) {
      case _MachineTypeFilter.all:
        // Show all machines
        break;
      case _MachineTypeFilter.washers:
        // Show all stacks (all stacks have washers)
        // This filter is for user preference/UI emphasis
        break;
      case _MachineTypeFilter.dryers:
        // Show all stacks (all stacks have dryers)
        // This filter is for user preference/UI emphasis
        break;
      case _MachineTypeFilter.free:
        // Show only stacks with at least one free machine
        roomMachines = roomMachines.where((stack) {
          return stack.washerStatus == MachineStatus.free ||
              stack.dryerStatus == MachineStatus.free;
        }).toList();
        break;
    }

    // Apply status filters
    if (statusFilters.isNotEmpty) {
      roomMachines = roomMachines.where((stack) {
        bool matchesFilter = false;

        // Free filter
        if (statusFilters.contains('free')) {
          if (stack.washerStatus == MachineStatus.free ||
              stack.dryerStatus == MachineStatus.free) {
            matchesFilter = true;
          }
        }

        // Finishing Soon filter
        if (statusFilters.contains('finishingSoon')) {
          if (stack.washerStatus == MachineStatus.finishingSoon ||
              stack.dryerStatus == MachineStatus.finishingSoon) {
            matchesFilter = true;
          }
        }

        return matchesFilter;
      }).toList();
    }

    if (roomMachines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_off,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No machines match filters',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: roomMachines.length,
        itemBuilder: (context, index) {
          final stack = roomMachines[index];
          return _MachineStackCard(stack: stack);
        },
      ),
    );
  }
}

/// Individual Machine Stack Card
/// Shows Dryer on top and Washer on bottom with status badges
class _MachineStackCard extends StatelessWidget {
  final MachineStack stack;

  const _MachineStackCard({required this.stack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack label
            Text(
              stack.label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Dryer (top)
            Expanded(
              child: _MachineWidget(
                machineType: 'Dryer',
                status: stack.dryerStatus,
                etaMinutes: stack.dryerEtaMinutes,
                icon: Icons.air,
                stack: stack,
              ),
            ),
            const SizedBox(height: 8),
            // Washer (bottom)
            Expanded(
              child: _MachineWidget(
                machineType: 'Washer',
                status: stack.washerStatus,
                etaMinutes: stack.washerEtaMinutes,
                icon: Icons.water_drop,
                stack: stack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual Machine Widget (Dryer or Washer)
class _MachineWidget extends StatelessWidget {
  final String machineType;
  final MachineStatus status;
  final int? etaMinutes;
  final IconData icon;
  final MachineStack stack;

  const _MachineWidget({
    required this.machineType,
    required this.status,
    this.etaMinutes,
    required this.icon,
    required this.stack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Status color and text
    Color statusColor;
    String statusText;
    Color backgroundColor;

    switch (status) {
      case MachineStatus.free:
        statusColor = Colors.green;
        statusText = 'Free';
        backgroundColor = Colors.green.withOpacity(0.1);
        break;
      case MachineStatus.inUse:
        statusColor = Colors.orange;
        statusText = 'In Use';
        backgroundColor = Colors.orange.withOpacity(0.1);
        break;
      case MachineStatus.finishingSoon:
        statusColor = Colors.blue;
        statusText = 'Finishing Soon';
        backgroundColor = Colors.blue.withOpacity(0.1);
        break;
    }

    return InkWell(
      onTap: () => _showMachineDetailBottomSheet(context, machineType),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Machine icon
            Icon(
              icon,
              size: 24,
              color: statusColor,
            ),
            const SizedBox(height: 4),
            // Machine type
            Text(
              machineType,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusText,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ETA countdown
            if (etaMinutes != null && etaMinutes! > 0) ...[
              const SizedBox(height: 4),
              Text(
                '~${etaMinutes}m',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showMachineDetailBottomSheet(BuildContext context, String machineType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MachineDetailBottomSheet(
        stack: stack,
        machineType: machineType,
        status: status,
        etaMinutes: etaMinutes,
        icon: icon,
      ),
    );
  }
}

/// Machine Detail Bottom Sheet
/// Shows countdown timer and notification buttons
class _MachineDetailBottomSheet extends StatefulWidget {
  final MachineStack stack;
  final String machineType;
  final MachineStatus status;
  final int? etaMinutes;
  final IconData icon;

  const _MachineDetailBottomSheet({
    required this.stack,
    required this.machineType,
    required this.status,
    this.etaMinutes,
    required this.icon,
  });

  @override
  State<_MachineDetailBottomSheet> createState() =>
      _MachineDetailBottomSheetState();
}

class _MachineDetailBottomSheetState
    extends State<_MachineDetailBottomSheet> {
  int? _remainingMinutes;

  @override
  void initState() {
    super.initState();
    _remainingMinutes = widget.etaMinutes;
    // Start countdown timer if machine is in use
    if (_remainingMinutes != null && _remainingMinutes! > 0) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted && _remainingMinutes != null && _remainingMinutes! > 0) {
        setState(() {
          _remainingMinutes = _remainingMinutes! - 1;
        });
        if (_remainingMinutes! > 0) {
          _startCountdown();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Find room for location
    final room = halls.firstWhere(
      (r) => r.id == widget.stack.roomId,
      orElse: () => halls.first,
    );

    // Status color
    Color statusColor;
    String statusText;
    switch (widget.status) {
      case MachineStatus.free:
        statusColor = Colors.green;
        statusText = 'Available';
        break;
      case MachineStatus.inUse:
        statusColor = Colors.orange;
        statusText = 'In Use';
        break;
      case MachineStatus.finishingSoon:
        statusColor = Colors.blue;
        statusText = 'Finishing Soon';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(widget.icon, size: 32, color: statusColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.stack.label} - ${widget.machineType}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        room.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Countdown timer (if in use)
          if (_remainingMinutes != null && _remainingMinutes! > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Text(
                          '$_remainingMinutes',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          'minutes remaining',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          // Notification buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                if (widget.status != MachineStatus.free)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleNotifyWhenFree(context),
                      icon: const Icon(Icons.notifications_outlined),
                      label: const Text('Notify When Free'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                if (widget.status == MachineStatus.free)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleNotifyWhenFree(context),
                      icon: const Icon(Icons.notifications_active),
                      label: const Text('Machine is Available'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (widget.status != MachineStatus.free) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _handleNotifyAtEnd(context),
                      icon: const Icon(Icons.notification_important),
                      label: const Text('Notify At End'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _handleNotifyWhenFree(BuildContext context) {
    final room = halls.firstWhere(
      (r) => r.id == widget.stack.roomId,
      orElse: () => halls.first,
    );

    final alert = LaundryAlert(
      id: '${widget.stack.id}-${widget.machineType}-${DateTime.now().millisecondsSinceEpoch}',
      stackId: widget.stack.id,
      stackLabel: widget.stack.label,
      roomId: widget.stack.roomId,
      roomName: room.name,
      machineType: widget.machineType,
      type: AlertType.notifyWhenFree,
      createdAt: DateTime.now(),
    );

    LaundryAlertManager().addAlert(alert);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Alert set: You\'ll be notified when ${widget.machineType.toLowerCase()} is free',
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AlertCenterPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleNotifyAtEnd(BuildContext context) {
    final room = halls.firstWhere(
      (r) => r.id == widget.stack.roomId,
      orElse: () => halls.first,
    );

    final alert = LaundryAlert(
      id: '${widget.stack.id}-${widget.machineType}-${DateTime.now().millisecondsSinceEpoch}',
      stackId: widget.stack.id,
      stackLabel: widget.stack.label,
      roomId: widget.stack.roomId,
      roomName: room.name,
      machineType: widget.machineType,
      type: AlertType.notifyAtEnd,
      createdAt: DateTime.now(),
      gracePeriodMinutes: 5, // Default grace period
    );

    LaundryAlertManager().addAlert(alert);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Alert set: You\'ll be notified when ${widget.machineType.toLowerCase()} cycle ends',
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AlertCenterPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

