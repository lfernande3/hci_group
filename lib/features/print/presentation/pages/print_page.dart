import 'package:flutter/material.dart';
import '../../../../data/demo/printing_data.dart';

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

  /// Mock file picker - simulates selecting a file
  void _mockFilePicker() {
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

    setState(() {
      _selectedFileName = randomFile['name'] as String;
      _selectedFileSize = randomFile['size'] as int;
    });

    // Show feedback
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
                'File selected: ${randomFile['name']}',
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Submission'),
        // AppTheme automatically applied
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.print_outlined,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Step 1: Upload Document',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select a file to print. Supported formats: PDF, DOCX, PPTX, JPG, PNG',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // File upload button
            OutlinedButton.icon(
              onPressed: _mockFilePicker,
              icon: const Icon(Icons.upload_file),
              label: const Text('Select File'),
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
              const SizedBox(height: 24),
              // Info banner
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This is a demo file upload. No actual file is selected.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
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
                        color: colorScheme.onSurface.withOpacity(0.5),
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Step 2: Select Building',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Choose a building location. Queue count shows waiting print jobs.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.print,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Step 3: Select Print Type',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Choose your print option. Free B/W is available for students.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
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
                  },
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                
                // Step 4: Review & Submit (only show if all previous steps completed)
                if (_selectedPrintType != null) ...[
                  const SizedBox(height: 32),
                  _ReviewAndSubmitSection(
                    fileName: _selectedFileName!,
                    fileSize: _selectedFileSize!,
                    buildingId: _selectedBuildingId!,
                    printType: _selectedPrintType!,
                    jobId: _jobId,
                    isSubmitted: _isSubmitted,
                    onSubmit: () {
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
                    theme: theme,
                    colorScheme: colorScheme,
                    formatFileSize: _formatFileSize,
                  ),
                ],
              ],
            ],
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
  final VoidCallback onSubmit;
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
    required this.onSubmit,
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
            color: colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.assignment,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isSubmitted ? 'Step 4: Print Job Submitted' : 'Step 4: Review & Submit',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
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
                  color: colorScheme.onSurface.withOpacity(0.7),
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

        // Submit button or Release instructions
        if (!isSubmitted) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.send),
            label: const Text('Submit Print Job'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ] else if (instruction != null) ...[
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

