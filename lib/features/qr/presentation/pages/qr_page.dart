import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../data/demo/qr_data.dart';

/// QR code page for CityU ID
class QrPage extends StatelessWidget {
  const QrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final qrData = QrCodeData.getDemoQrCode();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CityU ID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh QR code (demo)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR code refreshed')),
              );
            },
            tooltip: 'Refresh QR Code',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Student Info Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Student Name
                      Text(
                        qrData.studentName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Student ID
                      Text(
                        'Student ID: ${qrData.studentId}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Program
                      Text(
                        qrData.program,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        qrData.email,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // QR Code Display
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // QR Code Pattern
                    _FakeQrCode(size: 250),
                    const SizedBox(height: 16),
                    // QR Code Value (for reference)
                    Text(
                      qrData.qrCodeValue,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Info Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'QR Code Information',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Valid Until',
                      value: qrData.formattedExpiryDate,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.security,
                      label: 'Status',
                      value: qrData.isExpired ? 'Expired' : 'Active',
                      valueColor: qrData.isExpired ? Colors.red : Colors.green,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Usage Instructions
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to Use',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InstructionItem(
                        icon: Icons.qr_code_scanner,
                        text: 'Show this QR code at campus facilities',
                      ),
                      _InstructionItem(
                        icon: Icons.library_books,
                        text: 'Use for library access and book borrowing',
                      ),
                      _InstructionItem(
                        icon: Icons.local_dining,
                        text: 'Pay at campus cafeterias and shops',
                      ),
                      _InstructionItem(
                        icon: Icons.meeting_room,
                        text: 'Access to restricted areas and rooms',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fake QR Code Widget - Creates a QR code-like pattern
class _FakeQrCode extends StatelessWidget {
  final double size;

  const _FakeQrCode({required this.size});

  @override
  Widget build(BuildContext context) {
    // Create a grid pattern that looks like a QR code
    final gridSize = 25; // 25x25 grid

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (context, index) {
          // Create a pattern that looks like a QR code
          final row = index ~/ gridSize;
          final col = index % gridSize;
          
          // Create corner squares and random pattern
          bool shouldFill = false;
          
          // Corner detection squares (top-left, top-right, bottom-left)
          if ((row < 7 && col < 7) || 
              (row < 7 && col >= gridSize - 7) ||
              (row >= gridSize - 7 && col < 7)) {
            shouldFill = (row == 0 || row == 6 || col == 0 || col == 6) ||
                        (row >= 2 && row <= 4 && col >= 2 && col <= 4);
          } else {
            // Random pattern for the rest
            shouldFill = (row + col * 3) % 7 < 3 || 
                       (row * col) % 11 < 4 ||
                       (row + col) % 5 == 0;
          }
          
          return Container(
            color: shouldFill ? Colors.black : Colors.white,
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InstructionItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
