import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/route_constants.dart';

/// Onboarding page with login/guest prompt and feature tutorials
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  bool _hasChosenAuthOption = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onAuthOptionChosen() {
    setState(() {
      _hasChosenAuthOption = true;
    });
    // Move to next page
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            physics: _currentPage == 0 && !_hasChosenAuthOption
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            children: [
              _buildLoginGuestPage(),
              _buildBookingTutorialPage(),
              _buildPrintTutorialPage(),
              _buildLaundryTutorialPage(),
              _buildACTutorialPage(),
              _buildVisitorTutorialPage(),
            ],
          ),
          
          // Page indicators
          if (_currentPage > 0)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.grey300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          
          // Navigation buttons
          if (_currentPage > 0)
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage < 5)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.grey500,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  ElevatedButton(
                    onPressed: _currentPage < 5 ? _nextPage : _completeOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage < 5 ? 'Next' : 'Get Started',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentPage < 5 ? Icons.arrow_forward : Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    onboardingProvider.completeOnboarding();
    context.go(RouteConstants.home);
  }

  void _skipOnboarding() {
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    onboardingProvider.skipOnboarding();
    context.go(RouteConstants.home);
  }

  // Login/Guest Selection Page
  Widget _buildLoginGuestPage() {
    return Container(
      decoration: const BoxDecoration(
        // CityU gradient background - orange to burgundy (matching next event widget)
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.0, 0.6],
          colors: [
            AppColors.secondaryOrange, // Orange
            AppColors.primary, // Burgundy
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo - increased size and padding to prevent cutoff
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Image.asset(
                        'assets/cityu_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 112,
                          height: 112,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 56,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'Welcome to CityUHK Mobile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Your gateway to campus services',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 64),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to login page
                    final result = await context.push(RouteConstants.login);
                    if (result == true && mounted) {
                      // User logged in successfully
                      _onAuthOptionChosen();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, color: AppColors.primary),
                      SizedBox(width: 12),
                      Text(
                        'Login with CityU Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Guest Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    // Continue as guest
                    _onAuthOptionChosen();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Continue as Guest',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'You can always login later from settings',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tutorial Pages
  Widget _buildTutorialPage({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Content
              Expanded(
                child: content,
              ),
              
              const SizedBox(height: 120), // Space for buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingTutorialPage() {
    return _buildTutorialPage(
      title: 'Room Booking',
      description: 'Reserve study rooms and facilities with ease',
      icon: Icons.meeting_room,
      color: AppColors.primary,
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTutorialStep(
              number: '1',
              title: 'Browse Available Rooms',
              description: 'View all available study rooms and facilities',
              icon: Icons.search,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '2',
              title: 'Select Date & Time',
              description: 'Choose your preferred date and time slot',
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '3',
              title: 'Confirm Booking',
              description: 'Complete your reservation instantly',
              icon: Icons.check_circle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintTutorialPage() {
    return _buildTutorialPage(
      title: 'Print Services',
      description: 'Print your documents from anywhere on campus',
      icon: Icons.print,
      color: AppColors.secondaryOrange,
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTutorialStep(
              number: '1',
              title: 'Upload Document',
              description: 'Select files from your device to print',
              icon: Icons.upload_file,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '2',
              title: 'Choose Settings',
              description: 'Set print options like color, copies, and paper size',
              icon: Icons.settings,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '3',
              title: 'Collect Your Prints',
              description: 'Pick up from any campus printer',
              icon: Icons.location_on,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaundryTutorialPage() {
    return _buildTutorialPage(
      title: 'Laundry Service',
      description: 'Book washing machines and dryers in your hall',
      icon: Icons.local_laundry_service,
      color: AppColors.secondaryPurple,
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTutorialStep(
              number: '1',
              title: 'Check Availability',
              description: 'See which machines are free in real-time',
              icon: Icons.wifi_tethering,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '2',
              title: 'Reserve Machine',
              description: 'Book your preferred washer or dryer',
              icon: Icons.access_time,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '3',
              title: 'Get Notified',
              description: 'Receive alerts when your laundry is done',
              icon: Icons.notifications_active,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildACTutorialPage() {
    return _buildTutorialPage(
      title: 'A/C Control',
      description: 'Control air conditioning in your room',
      icon: Icons.ac_unit,
      color: const Color(0xFF00BCD4), // Cyan color for A/C
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTutorialStep(
              number: '1',
              title: 'Connect to Your Room',
              description: 'Link your device to your room\'s A/C system',
              icon: Icons.devices,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '2',
              title: 'Adjust Temperature',
              description: 'Set your preferred temperature and fan speed',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '3',
              title: 'Schedule Settings',
              description: 'Save energy with automated schedules',
              icon: Icons.schedule,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitorTutorialPage() {
    return _buildTutorialPage(
      title: 'Visitor Registration',
      description: 'Register guests to visit your hall',
      icon: Icons.how_to_reg,
      color: const Color(0xFF4CAF50), // Green color for visitors
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTutorialStep(
              number: '1',
              title: 'Enter Visitor Details',
              description: 'Provide visitor information and visit purpose',
              icon: Icons.person_add,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '2',
              title: 'Select Visit Time',
              description: 'Choose when your guest will arrive and leave',
              icon: Icons.event,
            ),
            const SizedBox(height: 16),
            _buildTutorialStep(
              number: '3',
              title: 'Get Approval',
              description: 'Security will review and approve your request',
              icon: Icons.verified_user,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number badge
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}