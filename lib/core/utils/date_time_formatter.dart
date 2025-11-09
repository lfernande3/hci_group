/// Standardized date and time formatting utilities
/// Used across all features for consistent timestamp display
class DateTimeFormatter {
  /// Format time in 12-hour format (e.g., "2:30 PM")
  static String formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Format date in short format (e.g., "Mon, 15/11")
  static String formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${date.day}/${date.month}';
  }

  /// Format date with month name (e.g., "Mon, Nov 15")
  static String formatDateWithMonth(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  /// Format date and time together (e.g., "Mon, 15/11, 2:30 PM")
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)}, ${formatTime(dateTime)}';
  }

  /// Format date and time with smart relative labels (Today, Tomorrow, etc.)
  static String formatDateTimeSmart(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    if (targetDate == today) {
      return 'Today, ${formatTime(dateTime)}';
    } else if (targetDate == tomorrow) {
      return 'Tomorrow, ${formatTime(dateTime)}';
    } else {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final weekday = weekdays[dateTime.weekday - 1];
      return '$weekday, ${dateTime.day}/${dateTime.month}/${dateTime.year} ${formatTime(dateTime)}';
    }
  }

  /// Format date and time compact (e.g., "Mon, 15/11 2:30 PM")
  static String formatDateTimeCompact(DateTime dateTime) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[dateTime.weekday - 1]}, ${dateTime.day}/${dateTime.month} ${formatTime(dateTime)}';
  }

  /// Format time ago (e.g., "5m ago", "2h ago", "3d ago")
  static String formatTimeAgo(DateTime dateTime) {
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

  /// Format time range (e.g., "2:30 PM - 4:00 PM")
  static String formatTimeRange(DateTime startTime, DateTime endTime) {
    return '${formatTime(startTime)} - ${formatTime(endTime)}';
  }
}

