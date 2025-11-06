import 'package:flutter/material.dart';
import '../../../../data/demo/dorm_services_data.dart';

/// Visitor Registration page with NFC tap to verify student identity
class VisitorRegistrationPage extends StatefulWidget {
  const VisitorRegistrationPage({super.key});

  @override
  State<VisitorRegistrationPage> createState() => _VisitorRegistrationPageState();
}

enum _VerificationState {
  initial,      // Initial state - showing instructions
  scanning,     // NFC scanning in progress
  success,      // Verification successful
  error,        // Verification failed
}

class _VisitorRegistrationPageState extends State<VisitorRegistrationPage>
    with SingleTickerProviderStateMixin {
  _VerificationState _state = _VerificationState.initial;
  String? _verifiedStudentId;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _state = _VerificationState.scanning;
      _errorMessage = null;
    });
    // No auto-simulation - user must tap the NFC area (T-244)
  }

  void _simulateNFCTap() {
    // Mock student ID (in real app, this would come from NFC reader)
    // For demo, randomly select a valid or invalid ID to show both success and error states
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    String mockStudentId;
    bool isValid;

    if (random == 0) {
      // 33% chance of invalid ID for demo purposes
      mockStudentId = '1234'; // Too short - invalid
      isValid = false;
    } else {
      // 67% chance of valid ID
      mockStudentId = '12345678'; // Valid format
      isValid = mockNfcValidation(mockStudentId);
    }

    if (isValid) {
      setState(() {
        _state = _VerificationState.success;
        _verifiedStudentId = mockStudentId;
      });
      _animationController.forward();
    } else {
      setState(() {
        _state = _VerificationState.error;
        _errorMessage = 'Invalid student ID. Please try again.';
      });
    }
  }

  void _reset() {
    setState(() {
      _state = _VerificationState.initial;
      _verifiedStudentId = null;
      _errorMessage = null;
    });
    _animationController.reset();
  }

  void _retry() {
    _startScanning();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Registration'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              _HeaderCard(
                theme: theme,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 24),

              // Main Content based on state
              if (_state == _VerificationState.initial)
                _InitialStateView(
                  theme: theme,
                  colorScheme: colorScheme,
                  onStartScanning: _startScanning,
                )
              else if (_state == _VerificationState.scanning)
                _ScanningStateView(
                  theme: theme,
                  colorScheme: colorScheme,
                  onNFCTap: _simulateNFCTap,
                )
              else if (_state == _VerificationState.success)
                _SuccessStateView(
                  theme: theme,
                  colorScheme: colorScheme,
                  studentId: _verifiedStudentId!,
                  scaleAnimation: _scaleAnimation,
                  fadeAnimation: _fadeAnimation,
                  onReset: _reset,
                )
              else if (_state == _VerificationState.error)
                _ErrorStateView(
                  theme: theme,
                  colorScheme: colorScheme,
                  errorMessage: _errorMessage ?? 'Verification failed',
                  onRetry: _retry,
                  onReset: _reset,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header Card Widget
class _HeaderCard extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _HeaderCard({
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_add,
                  color: colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'NFC Tap to Verify',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Ask the host student to tap their CityU Student ID card on your phone\'s NFC reader to verify their identity.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Initial State View - Instructions and Start Button
class _InitialStateView extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onStartScanning;

  const _InitialStateView({
    required this.theme,
    required this.colorScheme,
    required this.onStartScanning,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // NFC Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.nfc,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Instructions
            Text(
              'Ready to Scan',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _InstructionItem(
              icon: Icons.phone_android,
              text: 'Ensure NFC is enabled on your device',
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _InstructionItem(
              icon: Icons.credit_card,
              text: 'Have the host student ready with their CityU Student ID',
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _InstructionItem(
              icon: Icons.touch_app,
              text: 'Tap the ID card on the back of your phone',
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 32),

            // Start Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onStartScanning,
                icon: const Icon(Icons.nfc),
                label: const Text('Start NFC Scan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is a demo. In the full version, NFC will read encrypted student ID data.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
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
}

/// Instruction Item Widget
class _InstructionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _InstructionItem({
    required this.icon,
    required this.text,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

/// Scanning State View - Shows scanning animation with tappable NFC area
class _ScanningStateView extends StatefulWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onNFCTap;

  const _ScanningStateView({
    required this.theme,
    required this.colorScheme,
    required this.onNFCTap,
  });

  @override
  State<_ScanningStateView> createState() => _ScanningStateViewState();
}

class _ScanningStateViewState extends State<_ScanningStateView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _tapController;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isTapped) return; // Prevent multiple taps
    
    setState(() {
      _isTapped = true;
    });
    
    // Visual feedback animation
    _tapController.forward().then((_) {
      _tapController.reverse();
    });
    
    // Simulate processing delay
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onNFCTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Tappable NFC Area
            GestureDetector(
              onTap: _handleTap,
              child: AnimatedBuilder(
                animation: Listenable.merge([_pulseController, _tapController]),
                builder: (context, child) {
                  final tapScale = 1.0 - (_tapController.value * 0.1);
                  final pulseScale = 1.0 + (_pulseController.value * 0.2);
                  
                  return Transform.scale(
                    scale: tapScale * pulseScale,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: _isTapped
                            ? widget.colorScheme.primaryContainer
                            : widget.colorScheme.primaryContainer.withOpacity(
                                0.3 + (_pulseController.value * 0.2),
                              ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.colorScheme.primary,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.nfc,
                            size: 80,
                            color: widget.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isTapped ? 'Processing...' : 'Tap Here',
                            style: widget.theme.textTheme.titleMedium?.copyWith(
                              color: widget.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!_isTapped) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Simulate ID Card Tap',
                              style: widget.theme.textTheme.bodySmall?.copyWith(
                                color: widget.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            Text(
              _isTapped ? 'Reading ID Card...' : 'Ready to Scan',
              style: widget.theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isTapped
                  ? 'Processing student ID verification...'
                  : 'Tap the circle above to simulate tapping a CityU Student ID card',
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: widget.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Loading indicator (only show when processing)
            if (_isTapped) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Validating student ID...',
                style: widget.theme.textTheme.bodySmall?.copyWith(
                  color: widget.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ] else ...[
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    _InstructionItem(
                      icon: Icons.touch_app,
                      text: 'Tap the circle above to simulate NFC tap',
                      theme: widget.theme,
                      colorScheme: widget.colorScheme,
                    ),
                    const SizedBox(height: 8),
                    _InstructionItem(
                      icon: Icons.info_outline,
                      text: 'In a real scenario, the student would tap their ID card on your phone',
                      theme: widget.theme,
                      colorScheme: widget.colorScheme,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Success State View - Shows success animation
class _SuccessStateView extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final String studentId;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final VoidCallback onReset;

  const _SuccessStateView({
    required this.theme,
    required this.colorScheme,
    required this.studentId,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success Animation
            FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            FadeTransition(
              opacity: fadeAnimation,
              child: Text(
                'Verification Successful!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4CAF50),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            FadeTransition(
              opacity: fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Student ID Verified',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Student ID: $studentId',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            FadeTransition(
              opacity: fadeAnimation,
              child: Text(
                'The host student\'s identity has been verified. You can proceed with registration.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            FadeTransition(
              opacity: fadeAnimation,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onReset,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Register Another Visitor'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error State View - Shows error message
class _ErrorStateView extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final String errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onReset;

  const _ErrorStateView({
    required this.theme,
    required this.colorScheme,
    required this.errorMessage,
    required this.onRetry,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Error Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFE53935),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Verification Failed',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE53935),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onReset,
                child: const Text('Start Over'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

