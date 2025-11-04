import 'package:flutter/material.dart';
import '../../../events/data/models/event_model.dart';
import '../../../events/domain/entities/event.dart';

/// Timetable page with weekly grid view
class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  // Get current week's Monday
  DateTime get _currentWeekMonday {
    final now = DateTime.now();
    final daysFromMonday = now.weekday - 1;
    return DateTime(now.year, now.month, now.day - daysFromMonday);
  }

  // Demo timetable data based on screenshot
  List<EventModel> get _demoClasses {
    final monday = _currentWeekMonday;
    
    return [
      // Wednesday - CS3402-BOC, LT401, 09:00-12:00
      EventModel(
        id: 'class_1',
        title: 'CS3402',
        description: 'CS3402-BOC',
        startTime: DateTime(monday.year, monday.month, monday.day + 2, 9, 0),
        endTime: DateTime(monday.year, monday.month, monday.day + 2, 12, 0),
        location: 'Academic Building',
        room: 'LT401',
        type: EventType.lecture,
        courseCode: 'CS3402',
        instructor: 'BOC',
      ),
      // Thursday - CS3402-YEUNG, B7520, 11:00-12:00
      EventModel(
        id: 'class_2',
        title: 'CS3402',
        description: 'CS3402-YEUNG',
        startTime: DateTime(monday.year, monday.month, monday.day + 3, 11, 0),
        endTime: DateTime(monday.year, monday.month, monday.day + 3, 12, 0),
        location: 'Academic Building',
        room: 'B7520',
        type: EventType.tutorial,
        courseCode: 'CS3402',
        instructor: 'YEUNG',
      ),
      // Thursday - EE3070-YEUNG, G7610, 15:00-18:00
      EventModel(
        id: 'class_3',
        title: 'EE3070',
        description: 'EE3070-YEUNG',
        startTime: DateTime(monday.year, monday.month, monday.day + 3, 15, 0),
        endTime: DateTime(monday.year, monday.month, monday.day + 3, 18, 0),
        location: 'Academic Building',
        room: 'G7610',
        type: EventType.lecture,
        courseCode: 'EE3070',
        instructor: 'YEUNG',
      ),
      // Monday - EE2331-YEUNG, LT-7, 12:00-15:00
      EventModel(
        id: 'class_4',
        title: 'EE2331',
        description: 'EE2331-YEUNG',
        startTime: DateTime(monday.year, monday.month, monday.day, 12, 0),
        endTime: DateTime(monday.year, monday.month, monday.day, 15, 0),
        location: 'Academic Building',
        room: 'LT-7',
        type: EventType.lecture,
        courseCode: 'EE2331',
        instructor: 'YEUNG',
      ),
      // Monday - EE2331-YEUNG, B7530, 18:00-19:00
      EventModel(
        id: 'class_5',
        title: 'EE2331',
        description: 'EE2331-YEUNG',
        startTime: DateTime(monday.year, monday.month, monday.day, 18, 0),
        endTime: DateTime(monday.year, monday.month, monday.day, 19, 0),
        location: 'Academic Building',
        room: 'B7530',
        type: EventType.tutorial,
        courseCode: 'EE2331',
        instructor: 'YEUNG',
      ),
      // Tuesday - EE3210-YEUNG, LT-10, 12:00-15:00
      EventModel(
        id: 'class_6',
        title: 'EE3210',
        description: 'EE3210-YEUNG',
        startTime: DateTime(monday.year, monday.month, monday.day + 1, 12, 0),
        endTime: DateTime(monday.year, monday.month, monday.day + 1, 15, 0),
        location: 'Academic Building',
        room: 'LT-10',
        type: EventType.lecture,
        courseCode: 'EE3210',
        instructor: 'YEUNG',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Semester indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: theme.colorScheme.surface,
            child: Text(
              'Semester A 2024/25',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Day headers
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                // Time column header (empty)
                SizedBox(
                  width: 50,
                  child: Container(),
                ),
                // Day headers
                ...['M', 'T', 'W', 'R', 'F', 'S'].asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  final isToday = (now.weekday - 1) == index;
                  
                  return Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: isToday ? Colors.green : theme.colorScheme.onSurface,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          
          // Timetable grid
          Expanded(
            child: _TimetableGrid(
              classes: _demoClasses,
              currentWeekMonday: _currentWeekMonday,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimetableGrid extends StatelessWidget {
  final List<EventModel> classes;
  final DateTime currentWeekMonday;

  const _TimetableGrid({
    required this.classes,
    required this.currentWeekMonday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    
    // Hours to display (09:00 to 22:00)
    final hours = List.generate(14, (i) => 9 + i);
    final totalHeight = hours.length * 60.0;
    
    return SingleChildScrollView(
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            // Grid content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time axis
                Container(
                  width: 50,
                  child: Column(
                    children: hours.map((hour) {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: theme.colorScheme.outline.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            hour.toString().padLeft(2, '0'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // Day columns
                Expanded(
                  child: Row(
                    children: List.generate(6, (dayIndex) {
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: dayIndex < 5
                                  ? BorderSide(
                                      color: theme.colorScheme.outline.withOpacity(0.1),
                                      width: 1,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Grid cells
                              Column(
                                children: hours.map((hour) {
                                  return Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: theme.colorScheme.outline.withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              // Class blocks
                              ..._buildClassBlocks(context, dayIndex),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            
            // Current time indicator
            if (now.hour >= 9 && now.hour < 22)
              Positioned(
                left: 0,
                top: ((now.hour - 9) * 60.0) + (now.minute / 60.0) * 60.0,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: Text(
                        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildClassBlocks(BuildContext context, int dayIndex) {
    final day = currentWeekMonday.add(Duration(days: dayIndex));
    
    // Find classes for this day
    final dayClasses = classes.where((classEvent) {
      final classDay = classEvent.startTime;
      return classDay.year == day.year &&
          classDay.month == day.month &&
          classDay.day == day.day;
    }).toList();
    
    return dayClasses.map((classEvent) {
      final startHour = classEvent.startTime.hour;
      final startMinute = classEvent.startTime.minute;
      
      final startPosition = ((startHour - 9) * 60) + (startMinute / 60.0) * 60;
      final duration = classEvent.endTime.difference(classEvent.startTime);
      final height = duration.inMinutes.toDouble();
      
      return Positioned(
        top: startPosition,
        left: 2,
        right: 2,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow[700],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${classEvent.courseCode}-',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                classEvent.instructor ?? '',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                classEvent.room ?? '',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
