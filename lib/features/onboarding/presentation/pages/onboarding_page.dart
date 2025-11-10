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
  
  // State for tutorial step navigation
  int _currentTutorialStepIndex = 0;
  int _totalTutorialSteps = 0;
  VoidCallback? _nextTutorialStep;
  VoidCallback? _previousTutorialStep;

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
  
  void _onTutorialStepChanged(
    UIStep step,
    int currentIndex,
    int total,
    VoidCallback nextStep,
    VoidCallback previousStep,
  ) {
    setState(() {
      _currentTutorialStepIndex = currentIndex;
      _totalTutorialSteps = total;
      _nextTutorialStep = nextStep;
      _previousTutorialStep = previousStep;
    });
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
                // Clear tutorial step state when changing pages
                if (index == 0 || index == 6) {
                  _currentTutorialStepIndex = 0;
                  _totalTutorialSteps = 0;
                  _nextTutorialStep = null;
                  _previousTutorialStep = null;
                }
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
              _buildNavbarCustomizationTutorialPage(),
            ],
          ),
          
          // Navigation buttons (above page indicators)
          if (_currentPage > 0 && _totalTutorialSteps > 1)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentTutorialStepIndex > 0 && _previousTutorialStep != null)
                    TextButton.icon(
                      onPressed: _previousTutorialStep,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Previous', style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  if (_currentTutorialStepIndex > 0 && _currentTutorialStepIndex < _totalTutorialSteps - 1)
                    const SizedBox(width: 12),
                  if (_currentTutorialStepIndex < _totalTutorialSteps - 1 && _nextTutorialStep != null)
                    ElevatedButton.icon(
                      onPressed: _nextTutorialStep,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Next', style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                ],
              ),
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
                  7,
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
          
          // Swipe instruction (between dots and skip button)
          if (_currentPage > 0 && _currentPage < 6)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swipe, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        'Swipe to see more features',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Skip button (bottom left corner)
          if (_currentPage > 0 && _currentPage < 6)
            Positioned(
              bottom: 32,
              left: 24,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.grey500,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          
          // Get Started button (only on last page)
          if (_currentPage == 6)
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: Center(
                child: ElevatedButton(
                  onPressed: _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                
                // Icon and Title inline
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon - smaller and inline
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Title - inline with icon
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Description - below icon and title
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 20),
                
                // Content - flexible and scrollable
                content,
                
                const SizedBox(height: 20),
              ],
            ),
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
      content: _InteractiveUIDemo(
        onStepChanged: _onTutorialStepChanged,
        steps: [
          UIStep(
            title: 'Select a Room Type',
            description: 'Start by choosing the type of facility you want to book, like Study Rooms or Sports Facilities.',
            highlightWidget: _buildDemoRoomTypeTabs(),
            stepNumber: '1',
          ),
          UIStep(
            title: 'Find an Available Slot',
            description: 'Use the timetable to see all available rooms and times. Tap on a green slot to select it.',
            highlightWidget: _buildDemoTimetable(),
            stepNumber: '2',
          ),
          UIStep(
            title: 'Confirm Your Booking',
            description: 'After selecting a slot, review the details and tap confirm to finalize your reservation.',
            highlightWidget: _buildDemoConfirmButton(),
            stepNumber: '3',
          ),
        ],
      ),
    );
  }

  Widget _buildPrintTutorialPage() {
    return _buildTutorialPage(
      title: 'Print Services',
      description: 'Print your documents from anywhere on campus',
      icon: Icons.print,
      color: AppColors.secondaryOrange,
      content: _InteractiveUIDemo(
        onStepChanged: _onTutorialStepChanged,
        steps: [
          UIStep(
            title: 'Step 1: Upload Document',
            description: 'Tap the upload button to select a file from your device to begin the printing process.',
            highlightWidget: _buildDemoUploadButton(),
            stepNumber: '1',
          ),
          UIStep(
            title: 'Step 2: Choose Location & Type',
            description: 'Select a printer location on campus and then choose your desired print type, such as Free B/W.',
            highlightWidget: _buildDemoPrintSelection(),
            stepNumber: '2',
          ),
          UIStep(
            title: 'Step 3: Submit & Release',
            description: 'Submit your job to get a Job ID, then use it at the printer to release your document.',
            highlightWidget: _buildDemoJobIdCard(),
            stepNumber: '3',
          ),
        ],
      ),
    );
  }

  Widget _buildLaundryTutorialPage() {
    return _buildTutorialPage(
      title: 'Laundry Service',
      description: 'Book washing machines and dryers in your hall',
      icon: Icons.local_laundry_service,
      color: AppColors.secondaryPurple,
      content: _InteractiveUIDemo(
        onStepChanged: _onTutorialStepChanged,
        steps: [
          UIStep(
            title: 'Select Your Hall',
            description: 'First, choose your residential hall to see the laundry rooms available to you.',
            highlightWidget: _buildDemoHallSelector(),
            stepNumber: '1',
          ),
          UIStep(
            title: 'View Machine Status',
            description: 'See all washer/dryer stacks at a glance. Check if machines are free, in use, or finishing soon.',
            highlightWidget: _buildDemoMachineStack(),
            stepNumber: '2',
          ),
          UIStep(
            title: 'Book or Set Alerts',
            description: 'Tap a machine to book an available time slot or set a notification for when a machine is free.',
            highlightWidget: _buildDemoBookingActions(),
            stepNumber: '3',
          ),
        ],
      ),
    );
  }

  Widget _buildACTutorialPage() {
    return _buildTutorialPage(
      title: 'A/C Management',
      description: 'Check your balance and top up credits for your room A/C',
      icon: Icons.ac_unit,
      color: const Color(0xFF00BCD4), // Cyan color for A/C
      content: _InteractiveUIDemo(
        onStepChanged: _onTutorialStepChanged,
        steps: [
          UIStep(
            title: 'Check Your Balance',
            description: 'Quickly see your remaining A/C credit in hours and check the current status.',
            highlightWidget: _buildDemoACBalanceCard(),
            stepNumber: '1',
          ),
          UIStep(
            title: 'Top Up Credits',
            description: 'Tap the "Top Up" button to add more hours to your A/C balance using various payment methods.',
            highlightWidget: _buildDemoTopUpButton(),
            stepNumber: '2',
          ),
          UIStep(
            title: 'View Usage History',
            description: 'Scroll down to see a chart of your A/C usage over the last 24 hours to track your consumption.',
            highlightWidget: _buildDemoUsageChart(),
            stepNumber: '3',
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorTutorialPage() {
    return _buildTutorialPage(
      title: 'Visitor Registration',
      description: 'Register guests to visit your hall',
      icon: Icons.how_to_reg,
      color: const Color(0xFF4CAF50), // Green color for visitors
      content: _InteractiveUIDemo(
        onStepChanged: _onTutorialStepChanged,
        steps: [
          UIStep(
            title: 'Step 1: Start the Scan',
            description: 'Begin the process by tapping the "Start NFC Scan" button to prepare the phone for reading a student ID.',
            highlightWidget: _buildDemoStartScanButton(),
            stepNumber: '1',
          ),
          UIStep(
            title: 'Step 2: Tap the Student ID',
            description: 'Ask the host student to tap their ID card on the back of your phone to verify their identity.',
            highlightWidget: _buildDemoNFCScan(),
            stepNumber: '2',
          ),
          UIStep(
            title: 'Step 3: Verification Complete',
            description: 'Once the ID is successfully scanned, you will see a confirmation screen with the student\'s verified ID.',
            highlightWidget: _buildDemoVerificationSuccess(),
            stepNumber: '3',
          ),
        ],
      ),
    );
  }

  Widget _buildNavbarCustomizationTutorialPage() {
    return _buildTutorialPage(
      title: 'Customize Your Navigation',
      description: 'Personalize your bottom navigation bar',
      icon: Icons.tune,
      color: const Color(0xFF9C27B0), // Purple color for customization
      content: _InteractiveUIDemo(
        onStepChanged: _onTutorialStepChanged,
        steps: [
          UIStep(
            title: 'Go to Settings',
            description: 'Tap the Settings icon in your navigation bar at the bottom',
            highlightWidget: _buildDemoNavbarSettings(),
            stepNumber: '1',
          ),
          UIStep(
            title: 'Edit Navbar Items',
            description: 'Tap "Customize Bottom Navigation" to add, remove, or reorder items',
            highlightWidget: _buildDemoSettingsOption(),
            stepNumber: '2',
          ),
          UIStep(
            title: 'Drag to Reorder',
            description: 'Drag items to reorder them, or tap + to add new features to your navbar',
            highlightWidget: _buildDemoNavbarCustomization(),
            stepNumber: '3',
          ),
        ],
      ),
    );
  }

  // Demo UI Widget Builders
  Widget _buildDemoRoomTypeTabs() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DemoTab(icon: Icons.library_books, label: 'Study', isActive: true),
          _DemoTab(icon: Icons.school, label: 'Classroom'),
          _DemoTab(icon: Icons.sports_soccer, label: 'Sports'),
        ],
      ),
    );
  }

  Widget _buildDemoTimetable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Room A', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Row(
                children: [
                  _DemoTimeSlot(isBooked: true),
                  _DemoTimeSlot(isBooked: false, isSelected: true),
                  _DemoTimeSlot(isBooked: false),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Room B', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Row(
                children: [
                  _DemoTimeSlot(isBooked: false),
                  _DemoTimeSlot(isBooked: true),
                  _DemoTimeSlot(isBooked: true),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDemoConfirmButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 18),
          SizedBox(width: 6),
          Text(
            'Confirm Booking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoUploadButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryPurple, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryPurple.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.upload_file, size: 36, color: AppColors.secondaryPurple),
          const SizedBox(height: 10),
          Text(
            'Upload Document',
            style: TextStyle(
              color: AppColors.secondaryPurple,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to select files',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoPrintSelection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary),
          ),
          child: const Row(
            children: [
              Icon(Icons.business, color: AppColors.primary),
              SizedBox(width: 12),
              Expanded(child: Text('CMC Building', style: TextStyle(fontWeight: FontWeight.bold))),
              Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary),
          ),
          child: const Row(
            children: [
              Icon(Icons.print_outlined, color: AppColors.primary),
              SizedBox(width: 12),
              Expanded(child: Text('Free B/W', style: TextStyle(fontWeight: FontWeight.bold))),
              Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDemoJobIdCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Job ID',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'JOB123456',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoHallSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Select Hall',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Row(
            children: [
              Text(
                'Hall 8',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDemoMachineStack() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              'Stack A',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          _buildDemoMachineRow('Dryer', Icons.air, 'In Use', Colors.orange),
          const SizedBox(height: 6),
          _buildDemoMachineRow('Washer', Icons.water_drop, 'Free', Colors.green),
        ],
      ),
    );
  }

  Widget _buildDemoMachineRow(String type, IconData icon, String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoBookingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Book Machine',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Notify When Free',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDemoACBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.secondaryOrange, AppColors.primary],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('A/C Balance', style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 8),
          Row(
            children: [
              Text('48.5', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text('hours', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDemoStartScanButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.nfc, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Start NFC Scan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoNFCScan() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.1),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.nfc,
          size: 64,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildDemoVerificationSuccess() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 12),
          Text(
            'Verification Successful',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoTopUpButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: AppColors.primary),
          SizedBox(width: 8),
          Text(
            'Top Up',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoUsageChart() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _DemoBar(height: 0.3),
          _DemoBar(height: 0.5),
          _DemoBar(height: 0.8),
          _DemoBar(height: 0.4),
          _DemoBar(height: 0.6),
        ],
      ),
    );
  }

  Widget _buildDemoNavbarSettings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavbarIcon(Icons.home, false),
          const SizedBox(width: 16),
          _buildNavbarIcon(Icons.calendar_month, false),
          const SizedBox(width: 16),
          _buildNavbarIcon(Icons.map, false),
          const SizedBox(width: 16),
          _buildNavbarIcon(Icons.settings, true), // Highlighted
        ],
      ),
    );
  }

  Widget _buildNavbarIcon(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: isActive ? AppColors.primary : Colors.grey,
        size: 22,
      ),
    );
  }

  Widget _buildDemoSettingsOption() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.navigation, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Navbar Items',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Customize Bottom Navigation',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }

  Widget _buildDemoNavbarCustomization() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current items section
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'Current Navigation Items',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                _buildNavbarItemRow(Icons.home, 'Home', true),
                const SizedBox(height: 6),
                _buildNavbarItemRow(Icons.calendar_month, 'Calendar', true),
                const SizedBox(height: 6),
                _buildNavbarItemRow(Icons.map, 'Map', true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Available items section
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'Available Items',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                _buildNavbarItemRow(Icons.print, 'Print', false),
                const SizedBox(height: 6),
                _buildNavbarItemRow(Icons.event_available, 'Booking', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbarItemRow(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.primary.withOpacity(0.3) : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? AppColors.primary : Colors.grey[600], size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primary : Colors.grey[700],
              ),
            ),
          ),
          if (isActive)
            Icon(Icons.drag_handle, color: Colors.grey[400], size: 18)
          else
            Icon(Icons.add_circle_outline, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}

// Data class for UI steps
class UIStep {
  final String title;
  final String description;
  final Widget highlightWidget;
  final String stepNumber;

  UIStep({
    required this.title,
    required this.description,
    required this.highlightWidget,
    required this.stepNumber,
  });
}

// Interactive UI Demo widget with step-by-step highlights
class _InteractiveUIDemo extends StatefulWidget {
  final List<UIStep> steps;
  final Function(UIStep step, int currentIndex, int total, VoidCallback nextStep, VoidCallback previousStep)? onStepChanged;

  const _InteractiveUIDemo({
    required this.steps,
    this.onStepChanged,
  });

  @override
  State<_InteractiveUIDemo> createState() => _InteractiveUIDemoState();
}

class _InteractiveUIDemoState extends State<_InteractiveUIDemo>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Notify initial step
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onStepChanged != null) {
        widget.onStepChanged!(
          widget.steps[_currentStep],
          _currentStep,
          widget.steps.length,
          _nextStep,
          _previousStep,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      if (widget.onStepChanged != null) {
        widget.onStepChanged!(
          widget.steps[_currentStep],
          _currentStep,
          widget.steps.length,
          _nextStep,
          _previousStep,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      if (widget.onStepChanged != null) {
        widget.onStepChanged!(
          widget.steps[_currentStep],
          _currentStep,
          widget.steps.length,
          _nextStep,
          _previousStep,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Step description - informational card style (distinct from demo buttons)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main card with uniform border
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step indicator with icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Step ${_currentStep + 1} of ${widget.steps.length}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              step.stepNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                step.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Colored left border accent
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Animated highlighted widget
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3 * _fadeAnimation.value),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    step.highlightWidget,
                    // Tap indicator - smaller
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DemoTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _DemoTab({required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppColors.primary : Colors.grey[600], size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppColors.primary : Colors.grey[600],
            ),
          )
        ],
      ),
    );
  }
}

class _DemoTimeSlot extends StatelessWidget {
  final bool isBooked;
  final bool isSelected;

  const _DemoTimeSlot({this.isBooked = false, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isSelected) {
      color = AppColors.primary;
    } else if (isBooked) {
      color = Colors.grey[300]!;
    } else {
      color = Colors.green.withOpacity(0.4);
    }
    return Container(
      width: 40,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
      ),
    );
  }
}

class _DemoBar extends StatelessWidget {
  final double height;
  const _DemoBar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 100 * height,
      color: AppColors.primary.withOpacity(0.6),
    );
  }
}