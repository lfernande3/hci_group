import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/demo/events_data.dart';
import '../../../../core/utils/date_time_formatter.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/constants/route_constants.dart';

/// Events Dashboard page with event feed
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> _displayedEvents = allEvents;
  
  // Filter state
  EventCategory? _selectedCategory;
  EventLanguage? _selectedLanguage;
  String? _selectedTimeFilter; // 'today', 'thisWeek', or null
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _applyFilters();
  }

  void _applyFilters() {
    List<Event> filtered = List.from(allEvents);

    // Apply category filter
    if (_selectedCategory != null) {
      filtered = filtered.where((e) => e.category == _selectedCategory).toList();
    }

    // Apply language filter
    if (_selectedLanguage != null) {
      filtered = filtered.where((e) => e.language == _selectedLanguage).toList();
    }

    // Apply time filter
    if (_selectedTimeFilter != null) {
      final now = DateTime.now();
      if (_selectedTimeFilter == 'today') {
        final todayStart = DateTime(now.year, now.month, now.day);
        filtered = filtered.where((e) {
          final eventDate = DateTime(e.startTime.year, e.startTime.month, e.startTime.day);
          final todayDate = DateTime(todayStart.year, todayStart.month, todayStart.day);
          return eventDate.isAtSameMomentAs(todayDate);
        }).toList();
      } else if (_selectedTimeFilter == 'thisWeek') {
        final weekStart = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 7));
        filtered = filtered.where((e) {
          return e.startTime.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                 e.startTime.isBefore(weekEnd.add(const Duration(days: 1)));
        }).toList();
      }
    }

    // Apply search filter (search within filtered results)
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      filtered = filtered.where((e) {
        return e.title.toLowerCase().contains(lowerQuery) ||
               e.organizer.toLowerCase().contains(lowerQuery) ||
               (e.description?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }

    // Sort by start time (upcoming first)
    filtered.sort((a, b) => a.startTime.compareTo(b.startTime));

    setState(() {
      _displayedEvents = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Dashboard'),
        // AppTheme automatically applied
      ),
      body: Column(
        children: [
          // Search Bar Section
          _SearchBarSection(
            searchController: _searchController,
            theme: theme,
            colorScheme: colorScheme,
          ),
          
          // Filter Chips Section
          _FilterChipsSection(
            selectedCategory: _selectedCategory,
            selectedLanguage: _selectedLanguage,
            selectedTimeFilter: _selectedTimeFilter,
            onCategoryChanged: (category) {
              setState(() {
                _selectedCategory = category;
              });
              _applyFilters();
            },
            onLanguageChanged: (language) {
              setState(() {
                _selectedLanguage = language;
              });
              _applyFilters();
            },
            onTimeFilterChanged: (timeFilter) {
              setState(() {
                _selectedTimeFilter = timeFilter;
              });
              _applyFilters();
            },
            theme: theme,
            colorScheme: colorScheme,
          ),
          
          // Event Feed
          Expanded(
            child: _displayedEvents.isEmpty
                ? _buildEmptyState(context, theme, colorScheme)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _displayedEvents.length,
                    itemBuilder: (context, index) {
                      final event = _displayedEvents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _EventCard(
                          event: event,
                          theme: theme,
                          colorScheme: colorScheme,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No events found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for Search Bar Section
class _SearchBarSection extends StatefulWidget {
  final TextEditingController searchController;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _SearchBarSection({
    required this.searchController,
    required this.theme,
    required this.colorScheme,
  });

  @override
  State<_SearchBarSection> createState() => _SearchBarSectionState();
}

class _SearchBarSectionState extends State<_SearchBarSection> {
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_updateClearButton);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_updateClearButton);
    super.dispose();
  }

  void _updateClearButton() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: widget.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: TextField(
        controller: widget.searchController,
        decoration: InputDecoration(
          hintText: 'Search events...',
          prefixIcon: Icon(
            Icons.search,
            color: widget.colorScheme.onSurface.withOpacity(0.6),
          ),
          suffixIcon: widget.searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: widget.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () {
                    widget.searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: widget.colorScheme.surfaceVariant.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: widget.theme.textTheme.bodyMedium,
      ),
    );
  }
}

/// Widget for Filter Chips Section
class _FilterChipsSection extends StatelessWidget {
  final EventCategory? selectedCategory;
  final EventLanguage? selectedLanguage;
  final String? selectedTimeFilter;
  final Function(EventCategory?) onCategoryChanged;
  final Function(EventLanguage?) onLanguageChanged;
  final Function(String?) onTimeFilterChanged;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _FilterChipsSection({
    required this.selectedCategory,
    required this.selectedLanguage,
    required this.selectedTimeFilter,
    required this.onCategoryChanged,
    required this.onLanguageChanged,
    required this.onTimeFilterChanged,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Category filters
            Text(
              'Category:',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            _FilterChip<EventCategory>(
              label: 'All',
              isSelected: selectedCategory == null,
              onTap: () => onCategoryChanged(null),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 6),
            _FilterChip<EventCategory>(
              label: 'Academic',
              isSelected: selectedCategory == EventCategory.academic,
              onTap: () => onCategoryChanged(EventCategory.academic),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 6),
            _FilterChip<EventCategory>(
              label: 'Sports',
              isSelected: selectedCategory == EventCategory.sports,
              onTap: () => onCategoryChanged(EventCategory.sports),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 6),
            _FilterChip<EventCategory>(
              label: 'Cultural',
              isSelected: selectedCategory == EventCategory.cultural,
              onTap: () => onCategoryChanged(EventCategory.cultural),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 16),
            
            // Language filters
            Text(
              'Language:',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            _FilterChip<EventLanguage>(
              label: 'All',
              isSelected: selectedLanguage == null,
              onTap: () => onLanguageChanged(null),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 6),
            _FilterChip<EventLanguage>(
              label: 'EN',
              isSelected: selectedLanguage == EventLanguage.en,
              onTap: () => onLanguageChanged(EventLanguage.en),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 6),
            _FilterChip<EventLanguage>(
              label: 'ZH',
              isSelected: selectedLanguage == EventLanguage.zh,
              onTap: () => onLanguageChanged(EventLanguage.zh),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 16),
            
            // Time filters
            Text(
              'Time:',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            _FilterChip<String>(
              label: 'All',
              isSelected: selectedTimeFilter == null,
              onTap: () => onTimeFilterChanged(null),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 6),
            _FilterChip<String>(
              label: 'Today',
              isSelected: selectedTimeFilter == 'today',
              onTap: () => onTimeFilterChanged('today'),
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 6),
            _FilterChip<String>(
              label: 'This Week',
              isSelected: selectedTimeFilter == 'thisWeek',
              onTap: () => onTimeFilterChanged('thisWeek'),
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Filter Chip Widget
class _FilterChip<T> extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.primary,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Widget for displaying an event card
class _EventCard extends StatelessWidget {
  final Event event;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _EventCard({
    required this.event,
    required this.theme,
    required this.colorScheme,
  });


  String _getCategoryLabel(EventCategory category) {
    switch (category) {
      case EventCategory.academic:
        return 'Academic';
      case EventCategory.sports:
        return 'Sports';
      case EventCategory.cultural:
        return 'Cultural';
    }
  }

  String _getLanguageLabel(EventLanguage language) {
    switch (language) {
      case EventLanguage.en:
        return 'EN';
      case EventLanguage.zh:
        return 'ZH';
    }
  }

  String _getRegistrationStatusLabel(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.open:
        return 'Open';
      case RegistrationStatus.closed:
        return 'Closed';
      case RegistrationStatus.waitlist:
        return 'Waitlist';
    }
  }

  Color _getCategoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.academic:
        return colorScheme.primary;
      case EventCategory.sports:
        return Colors.orange;
      case EventCategory.cultural:
        return Colors.purple;
    }
  }

  Color _getRegistrationStatusColor(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.open:
        return Colors.green;
      case RegistrationStatus.closed:
        return Colors.grey;
      case RegistrationStatus.waitlist:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.push(
            '${RouteConstants.events}/${event.id}',
            extra: event,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.organizer,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event.category)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getCategoryLabel(event.category),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getCategoryColor(event.category),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Time and venue row
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      DateTimeFormatter.formatDateTimeSmart(event.startTime),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.venue,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Badges row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Language badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getLanguageLabel(event.language),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ),
                  // Registration status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRegistrationStatusColor(event.registrationStatus)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getRegistrationStatusLabel(event.registrationStatus),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getRegistrationStatusColor(event.registrationStatus),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  // Source badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      event.source,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Action buttons row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Register action (T-235)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registration for "${event.title}" is a demo action'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.how_to_reg, size: 18),
                      label: const Text('Register'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Add to Calendar action (T-235)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added "${event.title}" to calendar (demo)'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text('Add to Calendar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

