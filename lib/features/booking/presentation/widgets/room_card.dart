import 'package:flutter/material.dart';
import '../../../../data/demo/booking_data.dart';

/// Room Card widget displaying room information
/// Shows: name, location, capacity, and equipment tags
class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback? onTap;

  const RoomCard({
    super.key,
    required this.room,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room name and location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              room.location,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Capacity badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${room.capacity}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Equipment tags
              if (room.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: room.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getTagIcon(tag),
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tag,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Get appropriate icon for equipment tag
  IconData _getTagIcon(String tag) {
    final lowerTag = tag.toLowerCase();
    if (lowerTag.contains('whiteboard') || lowerTag.contains('board')) {
      return Icons.rectangle;
    }
    if (lowerTag.contains('display') || lowerTag.contains('screen') || lowerTag.contains('hdmi')) {
      return Icons.tv;
    }
    if (lowerTag.contains('projector')) {
      return Icons.video_library;
    }
    if (lowerTag.contains('mic') || lowerTag.contains('microphone')) {
      return Icons.mic;
    }
    if (lowerTag.contains('power') || lowerTag.contains('outlet')) {
      return Icons.power;
    }
    if (lowerTag.contains('acoustic') || lowerTag.contains('sound')) {
      return Icons.music_note;
    }
    if (lowerTag.contains('piano')) {
      return Icons.piano;
    }
    if (lowerTag.contains('soundproof')) {
      return Icons.hearing;
    }
    if (lowerTag.contains('group') || lowerTag.contains('team')) {
      return Icons.group;
    }
    if (lowerTag.contains('quiet')) {
      return Icons.volume_off;
    }
    // Default icon
    return Icons.info_outline;
  }
}

