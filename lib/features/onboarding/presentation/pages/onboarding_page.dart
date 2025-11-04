import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/route_constants.dart';

/// Onboarding page with 5-step tour using intro_slider
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<ContentConfig> slides = [];

  @override
  void initState() {
    super.initState();
    // Don't initialize slides here - do it in build() method
  }

  void _initializeSlides() {
    slides = [
      _createWelcomeSlide(),
      _createLoginStatusSlide(),
      _createNextEventSlide(),
      _createNavigationSlide(),
      _createPermissionsSlide(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Initialize slides here where Theme.of(context) is available
    if (slides.isEmpty) {
      _initializeSlides();
    }
    
    return Scaffold(
      body: IntroSlider(
        key: UniqueKey(),
        listContentConfig: slides,
        onDonePress: _onDonePress,
        onSkipPress: _onSkipPress,
        renderSkipBtn: _buildSkipButton(),
        renderNextBtn: _buildNextButton(),
        renderDoneBtn: _buildDoneButton(),
        indicatorConfig: const IndicatorConfig(
          colorIndicator: AppColors.grey300,
          sizeIndicator: 8.0,
          colorActiveIndicator: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Text(
        'Skip',
        style: TextStyle(
          color: AppColors.grey500,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _onDonePress() {
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    onboardingProvider.completeOnboarding();
    context.go(RouteConstants.home);
  }

  void _onSkipPress() {
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    onboardingProvider.skipOnboarding();
    context.go(RouteConstants.home);
  }

  ContentConfig _createWelcomeSlide() {
    return ContentConfig(
      title: "Welcome to CityUHK Mobile",
      description: "Your gateway to academic life at City University of Hong Kong",
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      styleTitle: const TextStyle(
        color: AppColors.primary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica',
      ),
      styleDescription: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
        height: 1.5,
        fontFamily: 'Helvetica',
      ),
      centerWidget: _buildWelcomeContent(),
    );
  }

  ContentConfig _createLoginStatusSlide() {
    return ContentConfig(
      title: "Your Account Status",
      description: "See your login status clearly in the app bar",
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      styleTitle: const TextStyle(
        color: AppColors.primary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica',
      ),
      styleDescription: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
        height: 1.5,
        fontFamily: 'Helvetica',
      ),
      centerWidget: _buildLoginStatusContent(),
    );
  }

  ContentConfig _createNextEventSlide() {
    return ContentConfig(
      title: "Next Event Widget",
      description: "Keep track of your next class or event at a glance",
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      styleTitle: const TextStyle(
        color: AppColors.primary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica',
      ),
      styleDescription: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
        height: 1.5,
        fontFamily: 'Helvetica',
      ),
      centerWidget: _buildNextEventContent(),
    );
  }

  ContentConfig _createNavigationSlide() {
    return ContentConfig(
      title: "Customize Navigation",
      description: "Personalize your bottom navigation with up to 5 shortcuts",
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      styleTitle: const TextStyle(
        color: AppColors.primary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica',
      ),
      styleDescription: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
        height: 1.5,
        fontFamily: 'Helvetica',
      ),
      centerWidget: _buildNavigationContent(),
    );
  }

  ContentConfig _createPermissionsSlide() {
    return ContentConfig(
      title: "Permissions & Setup",
      description: "Enable notifications and location services for the best experience",
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      styleTitle: const TextStyle(
        color: AppColors.primary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica',
      ),
      styleDescription: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
        height: 1.5,
        fontFamily: 'Helvetica',
      ),
      centerWidget: _buildPermissionsContent(),
    );
  }

  Widget _buildWelcomeContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CityUHK Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                'assets/cityu_logo.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // App preview mockup
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // App bar mockup
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Image.asset(
                        'assets/cityu_logo.png',
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'CityUHK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                
                // Content area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to CityUHK Mobile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your academic companion',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
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

  Widget _buildLoginStatusContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App bar with login status
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Image.asset(
                        'assets/cityu_logo.png',
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'CityUHK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: const Text(
                          'John Doe',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
          ),
          
          const SizedBox(height: 24),
          
          // Arrow pointing to login status
          const Icon(
            Icons.keyboard_arrow_up,
            size: 32,
            color: AppColors.secondaryOrange,
          ),
          
          const SizedBox(height: 16),
          
          // Explanation card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.3)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.secondaryOrange,
                  size: 24,
                ),
                SizedBox(height: 8),
                Text(
                  'Your login status is always visible',
                  style: TextStyle(
                    color: AppColors.secondaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap to login or see your profile',
                  style: TextStyle(
                    color: AppColors.secondaryOrange,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextEventContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Next event widget mockup
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.secondaryPurple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Week indicator
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryOrange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'LECTURE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'W5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Event details
                  const Text(
                    'Computer Networks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'CS3201',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Time and location
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      const Text('Today at 2:00 PM'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      const Text('AC1-LT9'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Arrow pointing to widget
          const Icon(
            Icons.keyboard_arrow_up,
            size: 32,
            color: AppColors.secondaryPurple,
          ),
          
          const SizedBox(height: 16),
          
          // Explanation card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondaryPurple.withOpacity(0.3)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.event,
                  color: AppColors.secondaryPurple,
                  size: 24,
                ),
                SizedBox(height: 8),
                Text(
                  'Your next event at a glance',
                  style: TextStyle(
                    color: AppColors.secondaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap to view full timetable',
                  style: TextStyle(
                    color: AppColors.secondaryPurple,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bottom navigation mockup
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.calendar_today, 'Timetable', true),
                _buildNavItem(Icons.chat_bubble, 'Chatbot', false),
                _buildNavItem(Icons.qr_code, 'CityU ID', false),
                _buildNavItem(Icons.account_circle, 'Account', false),
                _buildNavItem(Icons.settings, 'Settings', false),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Arrow pointing to navigation
          const Icon(
            Icons.keyboard_arrow_up,
            size: 32,
            color: AppColors.primary,
          ),
          
          const SizedBox(height: 16),
          
          // Explanation card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.touch_app,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(height: 8),
                Text(
                  'Customize your navigation',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Add, remove, or reorder up to 5 shortcuts',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? AppColors.primary : Colors.grey,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? AppColors.primary : Colors.grey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Permissions cards
          _buildPermissionItem(
            Icons.notifications,
            'Notifications',
            'Get alerts for upcoming classes and events',
            true,
          ),
          
          const SizedBox(height: 16),
          
          _buildPermissionItem(
            Icons.location_on,
            'Location',
            'Find nearby campus facilities and services',
            false,
          ),
          
          const SizedBox(height: 32),
          
          // Explanation card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.3)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.security,
                  color: AppColors.secondaryOrange,
                  size: 24,
                ),
                SizedBox(height: 8),
                Text(
                  'Your privacy matters',
                  style: TextStyle(
                    color: AppColors.secondaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You can change these settings anytime',
                  style: TextStyle(
                    color: AppColors.secondaryOrange,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(IconData icon, String title, String description, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled ? AppColors.primary : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isEnabled ? AppColors.primary : Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? AppColors.primary : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              // Handle permission toggle
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}