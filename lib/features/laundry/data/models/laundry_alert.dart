// Laundry Alert model for demo

enum AlertType { notifyWhenFree, notifyAtEnd }

class LaundryAlert {
  final String id;
  final String stackId;
  final String stackLabel;
  final String roomId;
  final String roomName;
  final String machineType; // "Washer" or "Dryer"
  final AlertType type;
  final DateTime createdAt;
  final int? gracePeriodMinutes; // 5 or 10 minutes

  const LaundryAlert({
    required this.id,
    required this.stackId,
    required this.stackLabel,
    required this.roomId,
    required this.roomName,
    required this.machineType,
    required this.type,
    required this.createdAt,
    this.gracePeriodMinutes,
  });

  String get typeDescription {
    switch (type) {
      case AlertType.notifyWhenFree:
        return 'Notify when free';
      case AlertType.notifyAtEnd:
        return 'Notify at end';
    }
  }
}

