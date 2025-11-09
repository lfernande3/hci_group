import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/colors.dart';

/// FAQ/Help page with common questions and tutorial replay option
class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Replay Tutorial Section - styled like next event widget
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tutorial',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Replay the app tutorial to learn about key features and how to use the CityUHK Mobile app.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _replayTutorial(context),
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('Replay Tutorial'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // FAQ Section
          Text(
            'Frequently Asked Questions',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // FAQ Items
          _FaqItem(
            question: 'How do I book a study room?',
            answer: 'Go to the Booking Services tab, select "Study Rooms", choose a room from the timetable, and tap on an available time slot (green). Confirm your booking in the dialog.',
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: 'How do I check laundry machine availability?',
            answer: 'Navigate to Laundry Management, select your dorm floor, and view the machine status. Green means available, orange means in use, and blue means finishing soon.',
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: 'How do I submit a print job?',
            answer: 'Go to Print Submission, select a file, choose a building location, select print type (Free B/W, Charged B/W, or Color), review your selection, and submit.',
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: 'How do I customize my navigation bar?',
            answer: 'Go to Settings > Navigation > Customize Bottom Navigation. You can add, remove, or reorder up to 5 navigation items to personalize your app experience.',
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: 'How do I add rooms to favorites?',
            answer: 'In the Booking Services page, tap the star icon next to any room name in the timetable grid. Toggle the "Show Favorites Only" switch to filter your favorite rooms.',
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: 'What should I do if file upload fails?',
            answer: 'If a file upload fails, an error dialog will appear with possible causes. Tap "Retry" to try again, or check your network connection and file size.',
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: 'How do I change the app theme?',
            answer: 'Go to Settings > Theme and select Light, Dark, or System default. The app will remember your preference.',
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: 'Where can I find my bookings?',
            answer: 'Tap the "My Bookings" icon in the Booking Services page (top right), or access it from your navigation bar if you\'ve added it as a shortcut.',
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 24),
          
          // Contact Support Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Need More Help?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'If you can\'t find the answer you\'re looking for, please contact our support team.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.email,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Email Support'),
                  subtitle: const Text('help@cityu.edu.hk'),
                  onTap: () {
                    // In a real app, this would open email client
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email: help@cityu.edu.hk'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _replayTutorial(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    
    // Reset onboarding to show tutorial again
    onboardingProvider.resetOnboarding();
    
    // Navigate to onboarding page
    context.go(RouteConstants.onboarding);
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tutorial will start now'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Widget for displaying FAQ items with expandable answers
class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.theme,
    required this.colorScheme,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Icon(
          _isExpanded ? Icons.help : Icons.help_outline,
          color: widget.colorScheme.primary,
        ),
        title: Text(
          widget.question,
          style: widget.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                widget.answer,
                style: widget.theme.textTheme.bodyMedium?.copyWith(
                  color: widget.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

