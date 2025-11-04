import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Onboarding state provider
class OnboardingProvider extends ChangeNotifier {
  static const String _onboardingBoxName = 'onboarding';
  static const String _isCompletedKey = 'is_completed';
  
  bool _isCompleted = false;
  bool _isLoading = false;
  int _currentStep = 0;
  final int _totalSteps = 5;
  late Box _box;

  bool get isCompleted => _isCompleted;
  bool get isLoading => _isLoading;
  int get currentStep => _currentStep;
  int get totalSteps => _totalSteps;
  bool get isLastStep => _currentStep >= _totalSteps - 1;
  bool get isFirstStep => _currentStep <= 0;
  double get progress => (_currentStep + 1) / _totalSteps;

  /// Initialize onboarding state
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      // Initialize Hive box
      _box = await Hive.openBox(_onboardingBoxName);
      
      // Load onboarding completion status from Hive
      _isCompleted = _box.get(_isCompletedKey, defaultValue: false);
    } catch (e) {
      // Handle error silently - assume onboarding is not completed
      _isCompleted = false;
    }
    
    _setLoading(false);
  }

  /// Check if onboarding should be shown
  bool get shouldShowOnboarding => !_isCompleted;

  /// Start onboarding
  void startOnboarding() {
    _currentStep = 0;
    notifyListeners();
  }

  /// Go to next step
  void nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Go to previous step
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Skip to specific step
  void goToStep(int step) {
    if (step >= 0 && step < _totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    _setLoading(true);
    
    try {
      // Save completion status to Hive
      await _box.put(_isCompletedKey, true);
      _isCompleted = true;
      _currentStep = 0;
      notifyListeners();
    } catch (e) {
      // Handle error - still mark as completed locally
      _isCompleted = true;
      _currentStep = 0;
    }
    
    _setLoading(false);
  }

  /// Skip onboarding
  Future<void> skipOnboarding() async {
    await completeOnboarding();
  }

  /// Reset onboarding (for testing purposes)
  Future<void> resetOnboarding() async {
    _setLoading(true);
    
    try {
      // Reset completion status in Hive
      await _box.put(_isCompletedKey, false);
      _isCompleted = false;
      _currentStep = 0;
      notifyListeners();
    } catch (e) {
      // Handle error - still reset locally
      _isCompleted = false;
      _currentStep = 0;
    }
    
    _setLoading(false);
  }

  /// Get step title
  String getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Welcome to CityUHK Mobile';
      case 1:
        return 'Your Account Status';
      case 2:
        return 'Next Event Widget';
      case 3:
        return 'Customize Navigation';
      case 4:
        return 'Permissions & Setup';
      default:
        return 'Welcome';
    }
  }

  /// Get step description
  String getStepDescription(int step) {
    switch (step) {
      case 0:
        return 'Your gateway to academic life at City University of Hong Kong';
      case 1:
        return 'See your login status clearly in the app bar';
      case 2:
        return 'Keep track of your next class or event at a glance';
      case 3:
        return 'Personalize your bottom navigation with up to 5 shortcuts';
      case 4:
        return 'Enable notifications and location services for the best experience';
      default:
        return '';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
