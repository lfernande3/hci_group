import 'package:flutter/material.dart';
import '../../../../data/demo/printing_data.dart';
import '../../../../core/theme/colors.dart';

/// Print Submission page with file upload mock
/// Step 1: Upload → Mock file picker
/// Step 2: Select Building → AC2 | CMC | Library (with queue count)
/// Step 3: Print Type → Free B/W | Charged B/W | Charged Color
/// Step 4: Review & Submit → Job ID + release steps
class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  String? _selectedFileName;
  int? _selectedFileSize;
  String? _selectedBuildingId;
  PrintType? _selectedPrintType;
  String? _jobId;
  bool _isSubmitted = false;
  bool _isUploading = false;
  
  // Scroll controller and keys for auto-scrolling
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _step2Key = GlobalKey();
  final GlobalKey _step3Key = GlobalKey();
  final GlobalKey _step4Key = GlobalKey();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  /// Scroll to a specific step after state update
  void _scrollToStep(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1, // Scroll to show near top
        );
      }
    });
  }

  /// Mock file picker - simulates selecting a file with potential errors
  Future<void> _mockFilePicker() async {
    // Simulate file selection with random demo files
    final demoFiles = [
      {'name': 'assignment_2024.pdf', 'size': 245678},
      {'name': 'research_paper.docx', 'size': 1024567},
      {'name': 'presentation_slides.pptx', 'size': 3456789},
      {'name': 'lab_report.pdf', 'size': 567890},
      {'name': 'essay_final.docx', 'size': 234567},
    ];

    final randomFile = demoFiles[
        DateTime.now().millisecondsSinceEpoch % demoFiles.length];

    final wasChangingFile = _selectedFileName != null;
    
    // Simulate upload process with potential failure (20% chance for demo)
    setState(() {
      _isUploading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate random upload failure (20% chance)
    final shouldFail = (DateTime.now().millisecondsSinceEpoch % 10) < 2;
    
    if (shouldFail) {
      setState(() {
        _isUploading = false;
      });
      
      // Show error dialog
      _showUploadErrorDialog();
      return;
    }

    // Success case
    setState(() {
      _selectedFileName = randomFile['name'] as String;
      _selectedFileSize = randomFile['size'] as int;
      _isUploading = false;
      // Reset submission state when changing file (but keep building/print type)
      if (wasChangingFile) {
        _jobId = null;
        _isSubmitted = false;
      }
    });
    
    // Auto-scroll to Step 2 after file selection
    if (!wasChangingFile) {
      _scrollToStep(_step2Key);
    }

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                wasChangingFile 
                    ? 'File changed to: ${randomFile['name']}'
                    : 'File selected: ${randomFile['name']}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show contextual error dialog for failed uploads
  void _showUploadErrorDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.error_outline,
                color: colorScheme.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Upload Failed'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unable to upload the selected file.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Possible causes:',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _ErrorCauseItem(
                    icon: Icons.wifi_off,
                    text: 'Network connection issue',
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                  const SizedBox(height: 4),
                  _ErrorCauseItem(
                    icon: Icons.storage,
                    text: 'File size too large',
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                  const SizedBox(height: 4),
                  _ErrorCauseItem(
                    icon: Icons.lock_outline,
                    text: 'File access permission denied',
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _mockFilePicker(); // Retry upload
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Get the current step number (1-4)
  int _getCurrentStep() {
    if (_isSubmitted) return 4;
    if (_selectedPrintType != null) return 4;
    if (_selectedBuildingId != null) return 3;
    if (_selectedFileName != null) return 2;
    return 1;
  }

  /// Check if submit button should be shown
  bool _shouldShowSubmitButton() {
    return _selectedFileName != null &&
        _selectedBuildingId != null &&
        _selectedPrintType != null &&
        !_isSubmitted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentStep = _getCurrentStep();
    final showSubmitButton = _shouldShowSubmitButton();

    return Scaffold(
      body: SafeArea(
        child: Column(
        children: [
          // Stepper widget at the top
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: _PrintStepper(
              currentStep: currentStep,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            // Wi-Fi Detection Banner (mock)
            if (_selectedBuildingId != null) ...[
              _WiFiDetectionBanner(
                buildingId: _selectedBuildingId!,
                theme: theme,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 16),
            ],
            
            // Header section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
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
                      Icon(
                        Icons.print_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Step 1: Upload Document',
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
                    'Select a file to print. Supported formats: PDF, DOCX, PPTX, JPG, PNG',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // File upload button
            OutlinedButton.icon(
              onPressed: _isUploading ? null : _mockFilePicker,
              icon: _isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(_isUploading ? 'Uploading...' : 'Select File'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Selected file display
            if (_selectedFileName != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedFileName!,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (_selectedFileSize != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  _formatFileSize(_selectedFileSize!),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Change file button
                        TextButton.icon(
                          onPressed: _isUploading ? null : _mockFilePicker,
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Change'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedFileName = null;
                              _selectedFileSize = null;
                              _selectedBuildingId = null; // Clear building selection too
                              _selectedPrintType = null; // Clear print type too
                              _jobId = null; // Clear job ID
                              _isSubmitted = false; // Reset submission state
                            });
                          },
                          tooltip: 'Remove file',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Empty state
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.1),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      size: 64,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No file selected',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap "Select File" to choose a document',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
            
            // Step 2: Building Selector (only show if file is selected)
            if (_selectedFileName != null) ...[
              const SizedBox(height: 32),
              // Step 2 header
              Container(
                key: _step2Key,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
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
                        Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Step 2: Select Building',
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
                      'Choose a building location. Queue count shows waiting print jobs.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Building cards
              ...queues.entries.map((entry) {
                final building = entry.value;
                final isSelected = _selectedBuildingId == building.buildingId;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedBuildingId = building.buildingId;
                        _selectedPrintType = null; // Clear print type when building changes
                      });
                      // Auto-scroll to Step 3 after building selection
                      _scrollToStep(_step3Key);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer.withOpacity(0.3)
                            : colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Building icon
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.business,
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Building info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        building.buildingName,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: colorScheme.primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                
                                // Queue preview
                                Row(
                                  children: [
                                    Icon(
                                      Icons.queue,
                                      size: 16,
                                      color: colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${building.waitingJobs} job${building.waitingJobs != 1 ? 's' : ''} in queue',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Online/Offline status
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: building.isOnline
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: building.isOnline
                                                  ? Colors.green
                                                  : Colors.orange,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            building.isOnline ? 'Online' : 'Offline',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: building.isOnline
                                                  ? (theme.brightness == Brightness.dark
                                                      ? Colors.green.shade300
                                                      : Colors.green.shade700)
                                                  : (theme.brightness == Brightness.dark
                                                      ? Colors.orange.shade300
                                                      : Colors.orange.shade700),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
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
                        ],
                      ),
                    ),
                  ),
                );
              }),
              
              // Step 3: Print Type Selector (only show if building is selected)
              if (_selectedBuildingId != null) ...[
                const SizedBox(height: 32),
                // Step 3 header
                Container(
                  key: _step3Key,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
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
                          Icon(
                            Icons.print,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Step 3: Select Print Type',
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
                        'Choose your print option. Free B/W is available for students.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Print type cards
                _PrintTypeCard(
                  printType: PrintType.freeBW,
                  title: 'Free B/W',
                  description: 'Free black & white printing',
                  price: 'Free',
                  icon: Icons.print_outlined,
                  isSelected: _selectedPrintType == PrintType.freeBW,
                  onTap: () {
                    setState(() {
                      _selectedPrintType = PrintType.freeBW;
                    });
                    // Auto-scroll to Step 4 after print type selection
                    _scrollToStep(_step4Key);
                  },
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 12),
                _PrintTypeCard(
                  printType: PrintType.chargedBW,
                  title: 'Charged B/W',
                  description: 'Paid black & white printing',
                  price: 'HK\$0.5/page',
                  icon: Icons.print,
                  isSelected: _selectedPrintType == PrintType.chargedBW,
                  onTap: () {
                    setState(() {
                      _selectedPrintType = PrintType.chargedBW;
                    });
                    // Auto-scroll to Step 4 after print type selection
                    _scrollToStep(_step4Key);
                  },
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 12),
                _PrintTypeCard(
                  printType: PrintType.chargedColor,
                  title: 'Charged Color',
                  description: 'Paid color printing',
                  price: 'HK\$2.0/page',
                  icon: Icons.color_lens,
                  isSelected: _selectedPrintType == PrintType.chargedColor,
                  onTap: () {
                    setState(() {
                      _selectedPrintType = PrintType.chargedColor;
                    });
                    // Auto-scroll to Step 4 after print type selection
                    _scrollToStep(_step4Key);
                  },
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                
                // Step 4: Review & Submit (only show if all previous steps completed)
                if (_selectedPrintType != null) ...[
                  const SizedBox(height: 32),
                  Container(
                    key: _step4Key,
                    child: _ReviewAndSubmitSection(
                      fileName: _selectedFileName!,
                      fileSize: _selectedFileSize!,
                      buildingId: _selectedBuildingId!,
                      printType: _selectedPrintType!,
                      jobId: _jobId,
                      isSubmitted: _isSubmitted,
                      theme: theme,
                      colorScheme: colorScheme,
                      formatFileSize: _formatFileSize,
                    ),
                  ),
                ],
              ],
            ],
              ],
              ),
            ),
          ),
          // Enhanced sticky submit button at bottom
          if (showSubmitButton)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Generate mock job ID
                      final mockJobId = 'JOB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                      setState(() {
                        _jobId = mockJobId;
                        _isSubmitted = true;
                      });
                      
                      // Show success snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Print job submitted! Job ID: $mockJobId',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 26),
                    label: const Text(
                      'Submit Print Job',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: colorScheme.onPrimary,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 22,
                      ),
                      minimumSize: const Size(double.infinity, 68),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}

/// Widget for Review & Submit section
class _ReviewAndSubmitSection extends StatelessWidget {
  final String fileName;
  final int fileSize;
  final String buildingId;
  final PrintType printType;
  final String? jobId;
  final bool isSubmitted;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final String Function(int) formatFileSize;

  const _ReviewAndSubmitSection({
    required this.fileName,
    required this.fileSize,
    required this.buildingId,
    required this.printType,
    this.jobId,
    required this.isSubmitted,
    required this.theme,
    required this.colorScheme,
    required this.formatFileSize,
  });

  String _getPrintTypeLabel(PrintType type) {
    switch (type) {
      case PrintType.freeBW:
        return 'Free B/W';
      case PrintType.chargedBW:
        return 'Charged B/W';
      case PrintType.chargedColor:
        return 'Charged Color';
    }
  }

  String _getPrintTypePrice(PrintType type) {
    switch (type) {
      case PrintType.freeBW:
        return 'Free';
      case PrintType.chargedBW:
        return 'HK\$0.5/page';
      case PrintType.chargedColor:
        return 'HK\$2.0/page';
    }
  }

  @override
  Widget build(BuildContext context) {
    final building = queues[buildingId];
    final instruction = getInstruction(buildingId, printType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step 4 header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
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
                  Icon(
                    Icons.assignment,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isSubmitted ? 'Step 4: Print Job Submitted' : 'Step 4: Review & Submit',
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
                isSubmitted
                    ? 'Your print job has been submitted. Follow the steps below to release your print.'
                    : 'Review your selections and submit your print job.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Review card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _ReviewRow(
                icon: Icons.description,
                label: 'File',
                value: fileName,
                colorScheme: colorScheme,
                theme: theme,
              ),
              const SizedBox(height: 12),
              _ReviewRow(
                icon: Icons.business,
                label: 'Building',
                value: building?.buildingName ?? buildingId,
                colorScheme: colorScheme,
                theme: theme,
              ),
              const SizedBox(height: 12),
              _ReviewRow(
                icon: Icons.print,
                label: 'Print Type',
                value: '${_getPrintTypeLabel(printType)} (${_getPrintTypePrice(printType)})',
                colorScheme: colorScheme,
                theme: theme,
              ),
              if (isSubmitted && jobId != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Job ID',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              jobId!,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Release instructions (submit button is now sticky at bottom)
        if (isSubmitted && instruction != null) ...[
          const SizedBox(height: 24),
          // Release instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.print_outlined,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Release Instructions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...instruction.steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            step,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Widget for review row
class _ReviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.theme,
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
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

/// Widget for Wi-Fi Detection Banner (mock)
class _WiFiDetectionBanner extends StatelessWidget {
  final String buildingId;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _WiFiDetectionBanner({
    required this.buildingId,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final building = queues[buildingId];
    final isOffline = building?.isOnline == false;

    // Mock Wi-Fi detection: show banner if building is offline or if we want to show general reminder
    // For demo purposes, we'll show it when building is offline
    if (!isOffline) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: Colors.orange.shade700,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect to CityU Wi-Fi',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? Colors.orange.shade300
                        : Colors.orange.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Connect to CityU Wi-Fi to print at ${building?.buildingName ?? buildingId}. All steps work offline with demo data.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? Colors.orange.shade200
                        : Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying print type selection card
class _PrintTypeCard extends StatelessWidget {
  final PrintType printType;
  final String title;
  final String description;
  final String price;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _PrintTypeCard({
    required this.printType,
    required this.title,
    required this.description,
    required this.price,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer.withOpacity(0.3)
              : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Print type icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Print type info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Price badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: printType == PrintType.freeBW
                    ? Colors.green.withOpacity(0.2)
                    : colorScheme.secondaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                price,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: printType == PrintType.freeBW
                      ? (theme.brightness == Brightness.dark
                          ? Colors.green.shade300
                          : Colors.green.shade700)
                      : colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying print submission stepper
class _PrintStepper extends StatelessWidget {
  final int currentStep;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _PrintStepper({
    required this.currentStep,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Upload', 'icon': Icons.upload_file},
      {'label': 'Building', 'icon': Icons.business},
      {'label': 'Print Type', 'icon': Icons.print},
      {'label': 'Review', 'icon': Icons.assignment},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(steps.length, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;
        final step = steps[index];

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Step indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? colorScheme.primary
                          : isActive
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceVariant,
                      border: Border.all(
                        color: isActive || isCompleted
                            ? colorScheme.primary
                            : colorScheme.outline.withOpacity(0.3),
                        width: isActive ? 2.5 : 1.5,
                      ),
                    ),
                  ),
                  // Icon or checkmark
                  if (isCompleted)
                    Icon(
                      Icons.check,
                      color: colorScheme.onPrimary,
                      size: 22,
                    )
                  else
                    Icon(
                      step['icon'] as IconData,
                          color: isActive
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.7),
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Step label
              Text(
                step['label'] as String,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isActive || isCompleted
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// Widget for displaying error cause items in error dialog
class _ErrorCauseItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _ErrorCauseItem({
    required this.icon,
    required this.text,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}

