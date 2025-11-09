import 'package:flutter/material.dart';
import '../../../../data/demo/laundry_data.dart';
import 'alert_center_page.dart';
import '../../data/models/laundry_alert.dart';
import '../../data/models/laundry_booking.dart';
import '../../../../core/theme/colors.dart';

/// Laundry Management page with room selector and machine status
class LaundryPage extends StatefulWidget {
  const LaundryPage({super.key});

  @override
  State<LaundryPage> createState() => _LaundryPageState();
}

enum _MachineTypeFilter { all, washers, dryers }

class _LaundryPageState extends State<LaundryPage> {
  String? _selectedHall;
  String? _selectedRoomId;
  _MachineTypeFilter _machineTypeFilter = _MachineTypeFilter.all;
  Set<String> _statusFilters = {}; // 'free', 'finishingSoon'
  final LaundryAlertManager _alertManager = LaundryAlertManager();

  @override
  void initState() {
    super.initState();
    // Default to first hall
    final availableHalls = getAvailableHalls();
    if (availableHalls.isNotEmpty) {
      _selectedHall = availableHalls.first;
      // Set the room ID to the selected hall
      final selectedRoom = getHallByName(_selectedHall!);
      if (selectedRoom != null) {
        _selectedRoomId = selectedRoom.id;
      }
    }
    // Listen to alert changes to update badge
    _alertManager.addListener(_onAlertsChanged);
    
    // Add some fake notifications for demo
    _addFakeNotifications();
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

  void _addFakeNotifications() {
    // Only add fake notifications if there are none already
    if (_alertManager.alerts.isNotEmpty) return;

    // Find machines that are finishing soon or free to create demo notifications
    final fakeDemoAlerts = [
      // Hall 8 - Stack B Dryer finishing in 8m
      LaundryAlert(
        id: 'demo-H8-B-dryer-${DateTime.now().millisecondsSinceEpoch}',
        stackId: 'H8-B',
        stackLabel: 'Stack B',
        roomId: 'HALL-8',
        roomName: 'Hall 8',
        machineType: 'Dryer',
        type: AlertType.notifyAtEnd,
        createdAt: DateTime.now().subtract(const Duration(minutes: 37)), // 45m cycle - 8m remaining
        gracePeriodMinutes: 5,
      ),
      // Hall 8 - Stack F Washer finishing in 1m  
      LaundryAlert(
        id: 'demo-H8-F-washer-${DateTime.now().millisecondsSinceEpoch + 1}',
        stackId: 'H8-F',
        stackLabel: 'Stack F',
        roomId: 'HALL-8',
        roomName: 'Hall 8',
        machineType: 'Washer',
        type: AlertType.notifyWhenFree,
        createdAt: DateTime.now().subtract(const Duration(minutes: 29)), // 30m cycle - 1m remaining
      ),
      // Hall 10 - Stack G Washer finishing in 2m
      LaundryAlert(
        id: 'demo-H10-G-washer-${DateTime.now().millisecondsSinceEpoch + 2}',
        stackId: 'H10-G',
        stackLabel: 'Stack G',
        roomId: 'HALL-10',
        roomName: 'Hall 10',
        machineType: 'Washer',
        type: AlertType.notifyAtEnd,
        createdAt: DateTime.now().subtract(const Duration(minutes: 28)), // 30m cycle - 2m remaining
        gracePeriodMinutes: 10,
      ),
      // Hall 11 - Stack D Dryer finishing in 1m
      LaundryAlert(
        id: 'demo-H11-D-dryer-${DateTime.now().millisecondsSinceEpoch + 3}',
        stackId: 'H11-D',
        stackLabel: 'Stack D',
        roomId: 'HALL-11',
        roomName: 'Hall 11',
        machineType: 'Dryer',
        type: AlertType.notifyWhenFree,
        createdAt: DateTime.now().subtract(const Duration(minutes: 44)), // 45m cycle - 1m remaining
      ),
    ];

    // Add the fake alerts
    for (final alert in fakeDemoAlerts) {
      _alertManager.addAlert(alert);
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
                          fontSize: 11,
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
          // Hall and Floor Selector (Dropdowns)
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hall Dropdown
                Row(
                  children: [
                    Text(
                      'Select Hall:',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedHall,
                        isExpanded: true,
                        underline: Container(
                          height: 2,
                          color: colorScheme.primary,
                        ),
                        items: getAvailableHalls().map((String hall) {
                          return DropdownMenuItem<String>(
                            value: hall,
                            child: Text(
                              hall,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newHall) {
                          setState(() {
                            _selectedHall = newHall;
                            // Update room ID when hall changes
                            if (newHall != null) {
                              final selectedRoom = getHallByName(newHall);
                              _selectedRoomId = selectedRoom?.id;
                            } else {
                              _selectedRoomId = null;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filter Section
          if (_selectedRoomId != null) ...[
            // Segmented Control for Machine Type
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SegmentedButton<_MachineTypeFilter>(
                segments: [
                  ButtonSegment(
                    value: _MachineTypeFilter.all,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('All'),
                    ),
                    icon: Icon(Icons.grid_view, size: 18),
                  ),
                  ButtonSegment(
                    value: _MachineTypeFilter.washers,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Washers'),
                    ),
                    icon: Icon(Icons.water_drop, size: 18),
                  ),
                  ButtonSegment(
                    value: _MachineTypeFilter.dryers,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Dryers'),
                    ),
                    icon: Icon(Icons.air, size: 18),
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
                    label: const Text('Finishing'),
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
          ],
          // Machine Stack Grid with floating banner
          Expanded(
            child: Stack(
              children: [
                _selectedRoomId == null
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
                // Floating banner at the bottom (like FloatingActionButton)
                if (_selectedRoomId != null)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        // CityU gradient background - orange to burgundy (matching next event widget)
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: [0.0, 0.6],
                          colors: [
                            AppColors.secondaryOrange, // Orange
                            AppColors.primary, // Burgundy
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.widgetAccent.withOpacity(0.3),
                          width: 1.5,
                        ),
                        // Subtle shadow for depth
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.widgetShadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Each stack contains a washer-dryer pair. Look for the "Pair" badge when both machines are available.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10), // Extra bottom padding for floating banner
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 4,
          childAspectRatio: 1.15,
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stack label with pair availability indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      stack.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Show "Pair Available" badge when both machines are free
                  if (stack.washerStatus == MachineStatus.free &&
                      stack.dryerStatus == MachineStatus.free)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 12,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Pair',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.green.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Dryer and Washer (vertical layout - dryer on top, washer on bottom)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MachineWidget(
                  machineType: 'Dryer',
                  status: stack.dryerStatus,
                  etaMinutes: stack.dryerEtaMinutes,
                  icon: Icons.air,
                  stack: stack,
                ),
                const SizedBox(height: 6),
                _MachineWidget(
                  machineType: 'Washer',
                  status: stack.washerStatus,
                  etaMinutes: stack.washerEtaMinutes,
                  icon: Icons.water_drop,
                  stack: stack,
                ),
              ],
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
        statusText = 'Finishing';
        backgroundColor = Colors.blue.withOpacity(0.1);
        break;
    }

    return InkWell(
      onTap: () => _showMachineDetailBottomSheet(context, machineType),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Icon and machine type
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: statusColor,
                ),
                const SizedBox(width: 6),
                Text(
                  machineType,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            // Right side: Status badge and ETA
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // ETA countdown (if applicable)
                if (etaMinutes != null && etaMinutes! > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    '~${etaMinutes}m',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
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
  
  // Debounce state to prevent duplicate alert taps
  bool _isProcessingAlert = false;
  DateTime? _lastAlertTapTime;
  static const Duration _debounceDuration = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _remainingMinutes = widget.etaMinutes;
    // Start countdown timer if machine is in use
    if (_remainingMinutes != null && _remainingMinutes! > 0) {
      _startCountdown();
    }
  }
  
  bool _canProcessAlert() {
    if (_isProcessingAlert) {
      return false;
    }
    
    final now = DateTime.now();
    if (_lastAlertTapTime != null) {
      final timeSinceLastTap = now.difference(_lastAlertTapTime!);
      if (timeSinceLastTap < _debounceDuration) {
        return false;
      }
    }
    
    return true;
  }
  
  void _setProcessingState(bool isProcessing) {
    if (mounted) {
      setState(() {
        _isProcessingAlert = isProcessing;
        if (isProcessing) {
          _lastAlertTapTime = DateTime.now();
        }
      });
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
        statusText = 'Finishing';
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
          // Booking and notification buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Booking section for available machines
                if (widget.status == MachineStatus.free) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleBookMachine(context),
                      icon: const Icon(Icons.schedule),
                      label: const Text('Book This Machine'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isProcessingAlert
                          ? null
                          : () => _handleNotifyWhenFree(context),
                      icon: _isProcessingAlert
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.notifications_outlined),
                      label: Text(_isProcessingAlert ? 'Processing...' : 'Get Notified Instead'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
                // Notification options for busy machines
                if (widget.status != MachineStatus.free) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isProcessingAlert 
                          ? null 
                          : () => _handleNotifyWhenFree(context),
                      icon: _isProcessingAlert
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.notifications_outlined),
                      label: Text(_isProcessingAlert ? 'Processing...' : 'Notify When Free'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isProcessingAlert
                          ? null
                          : () => _handleNotifyAtEnd(context),
                      icon: _isProcessingAlert
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.notification_important),
                      label: Text(_isProcessingAlert ? 'Processing...' : 'Notify At End'),
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
    // Debounce: prevent duplicate taps
    if (!_canProcessAlert()) {
      return;
    }
    
    _setProcessingState(true);
    
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
    
    // Reset processing state after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _setProcessingState(false);
    });
    
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
    // Debounce: prevent duplicate taps
    if (!_canProcessAlert()) {
      return;
    }
    
    _setProcessingState(true);
    
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
    
    // Reset processing state after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _setProcessingState(false);
    });
    
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

  void _handleBookMachine(BuildContext context) {
    Navigator.of(context).pop(); // Close current bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingTimeSlotBottomSheet(
        stack: widget.stack,
        machineType: widget.machineType,
      ),
    );
  }
}

/// Booking Time Slot Selection Bottom Sheet
class _BookingTimeSlotBottomSheet extends StatefulWidget {
  final MachineStack stack;
  final String machineType;

  const _BookingTimeSlotBottomSheet({
    required this.stack,
    required this.machineType,
  });

  @override
  State<_BookingTimeSlotBottomSheet> createState() =>
      _BookingTimeSlotBottomSheetState();
}

class _BookingTimeSlotBottomSheetState
    extends State<_BookingTimeSlotBottomSheet> {
  final LaundryBookingManager _bookingManager = LaundryBookingManager();
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedTimeSlot;
  List<TimeSlot> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    _loadTimeSlots();
  }

  void _loadTimeSlots() {
    final slots = _bookingManager.getAvailableTimeSlots(
      widget.stack.id,
      widget.machineType,
      _selectedDate,
    );
    setState(() {
      _timeSlots = slots;
      _selectedTimeSlot = null;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book ${widget.stack.label} - ${widget.machineType}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  room.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Date selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Date',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Today
                    _DateChip(
                      date: DateTime.now(),
                      label: 'Today',
                      isSelected: _isSameDay(_selectedDate, DateTime.now()),
                      onTap: () {
                        setState(() {
                          _selectedDate = DateTime.now();
                        });
                        _loadTimeSlots();
                      },
                    ),
                    const SizedBox(width: 8),
                    // Tomorrow
                    _DateChip(
                      date: DateTime.now().add(const Duration(days: 1)),
                      label: 'Tomorrow',
                      isSelected: _isSameDay(
                        _selectedDate,
                        DateTime.now().add(const Duration(days: 1)),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedDate = DateTime.now().add(const Duration(days: 1));
                        });
                        _loadTimeSlots();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Time slots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Time Slot',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          
          // Available time slots (scrollable)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _timeSlots.map((slot) {
                  if (!slot.isAvailable) return const SizedBox.shrink();
                  
                  final isSelected = _selectedTimeSlot == slot;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTimeSlot = slot;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withOpacity(0.5),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        slot.timeRangeText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // Book button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedTimeSlot != null
                    ? () => _confirmBooking(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _selectedTimeSlot != null
                      ? 'Book for ${_selectedTimeSlot!.timeRangeText}'
                      : 'Select a time slot to book',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _confirmBooking(BuildContext context) {
    if (_selectedTimeSlot == null) return;

    final room = halls.firstWhere(
      (r) => r.id == widget.stack.roomId,
      orElse: () => halls.first,
    );

    final booking = LaundryBooking(
      id: '${widget.stack.id}-${widget.machineType}-${DateTime.now().millisecondsSinceEpoch}',
      stackId: widget.stack.id,
      stackLabel: widget.stack.label,
      roomId: widget.stack.roomId,
      roomName: room.name,
      machineType: widget.machineType,
      startTime: _selectedTimeSlot!.start,
      endTime: _selectedTimeSlot!.end,
      status: BookingStatus.upcoming,
      userId: 'demo_user',
      createdAt: DateTime.now(),
    );

    _bookingManager.addBooking(booking);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Booking confirmed for ${widget.machineType} at ${_selectedTimeSlot!.timeRangeText}',
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

/// Date selection chip widget
class _DateChip extends StatelessWidget {
  final DateTime date;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateChip({
    required this.date,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

