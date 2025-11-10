import 'package:flutter/material.dart';
import '../../../../data/demo/dorm_services_data.dart';
import '../../../../core/theme/colors.dart';

/// A/C Management page showing balance and usage history
class ACManagementPage extends StatefulWidget {
  const ACManagementPage({super.key});

  @override
  State<ACManagementPage> createState() => _ACManagementPageState();
}

class _ACManagementPageState extends State<ACManagementPage> {
  late ACDetails _acDetails;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadACDetails();
  }

  void _loadACDetails() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _acDetails = getACDetails();
          _isLoading = false;
        });
      }
    });
  }

  void _onTopUpPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TopUpModal(
        currentBalance: _acDetails.balanceHours,
        onTopUpComplete: (topUpHours) {
          setState(() {
            // Update balance
            final newBalance = _acDetails.balanceHours + topUpHours;
            final newStatus = newBalance >= 20
                ? ACBalanceStatus.sufficient
                : newBalance >= 5
                    ? ACBalanceStatus.low
                    : ACBalanceStatus.critical;
            
            _acDetails = ACDetails(
              roomNumber: _acDetails.roomNumber,
              balanceHours: newBalance,
              status: newStatus,
              lastUpdated: DateTime.now(),
              usageHistory: _acDetails.usageHistory,
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('A/C Management'),
        actions: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () {
              _loadACDetails();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                _loadACDetails();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // A/C Balance Card
                    _ACBalanceCard(
                      acDetails: _acDetails,
                      theme: theme,
                      colorScheme: colorScheme,
                      onTopUpPressed: _onTopUpPressed,
                    ),
                    const SizedBox(height: 24),

                    // Usage History Section
                    _UsageHistorySection(
                      usageHistory: _acDetails.usageHistory,
                      theme: theme,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// A/C Balance Card widget
class _ACBalanceCard extends StatelessWidget {
  final ACDetails acDetails;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onTopUpPressed;

  const _ACBalanceCard({
    required this.acDetails,
    required this.theme,
    required this.colorScheme,
    required this.onTopUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = acDetails.status == ACBalanceStatus.sufficient
        ? 'Sufficient'
        : acDetails.status == ACBalanceStatus.low
            ? 'Low'
            : 'Critical';

    // Shadow color and badge color based on status
    Color shadowColor;
    Color badgeColor;
    double shadowBlur;
    double shadowSpread;
    switch (acDetails.status) {
      case ACBalanceStatus.sufficient:
        shadowColor = Colors.green;
        badgeColor = Colors.green.shade300;
        shadowBlur = 20.0;
        shadowSpread = 4.0;
        break;
      case ACBalanceStatus.low:
        shadowColor = Colors.orange;
        badgeColor = Colors.orange.shade300;
        shadowBlur = 18.0;
        shadowSpread = 3.0;
        break;
      case ACBalanceStatus.critical:
        shadowColor = Colors.red;
        badgeColor = Colors.red.shade300;
        shadowBlur = 25.0;
        shadowSpread = 5.0;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        // CityU gradient background - orange to burgundy
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.0, 0.6], // Later gradient point
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
          // Outer glow
          BoxShadow(
            color: shadowColor.withOpacity(0.6),
            blurRadius: shadowBlur,
            spreadRadius: shadowSpread,
            offset: const Offset(0, 4),
          ),
          // Inner glow for more visibility
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: shadowBlur * 0.5,
            spreadRadius: shadowSpread * 0.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A/C Balance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      acDetails.roomNumber,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: badgeColor.withOpacity(0.6), width: 1.5),
                  ),
                  child: Text(
                    statusText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Balance Display
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  formatBalanceHours(acDetails.balanceHours),
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'remaining',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Last Updated
            Row(
              children: [
                Icon(
                  Icons.update,
                  size: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(width: 6),
                Text(
                  'Last updated: ${_formatLastUpdated(acDetails.lastUpdated)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top-Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onTopUpPressed,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Top Up'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

/// Usage History Section widget
class _UsageHistorySection extends StatelessWidget {
  final List<ACUsageHour> usageHistory;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _UsageHistorySection({
    required this.usageHistory,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.widgetAccent.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Usage History (Last 24 Hours)',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Chart Container
            SizedBox(
              height: 200,
              child: _UsageChart(
                usageHistory: usageHistory,
                theme: theme,
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(height: 16),

            // Summary Stats
            _UsageSummary(
              usageHistory: usageHistory,
              theme: theme,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

/// Usage Chart widget (bar chart)
class _UsageChart extends StatelessWidget {
  final List<ACUsageHour> usageHistory;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _UsageChart({
    required this.usageHistory,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (usageHistory.isEmpty) {
      return Center(
        child: Text(
          'No usage data available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      );
    }

    // Find max usage for scaling
    final maxUsage = usageHistory
        .map((h) => h.usageHours)
        .reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: usageHistory.map((hour) {
        final height = maxUsage > 0 ? (hour.usageHours / maxUsage) : 0.0;
        final isCurrentHour = hour.hour.hour == DateTime.now().hour &&
            hour.hour.day == DateTime.now().day;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bar
                Container(
                  height: 150 * height.clamp(0.0, 1.0),
                  decoration: BoxDecoration(
                    color: isCurrentHour
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(0.6),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Hour label (show every 6 hours)
                if (hour.hour.hour % 6 == 0)
                  SizedBox(
                    height: 12,
                    child: Center(
                      child: Text(
                        '${hour.hour.hour}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 12),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Usage Summary widget
class _UsageSummary extends StatelessWidget {
  final List<ACUsageHour> usageHistory;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _UsageSummary({
    required this.usageHistory,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate statistics
    final totalUsage = usageHistory
        .map((h) => h.usageHours)
        .fold(0.0, (sum, hours) => sum + hours);
    final avgDailyUsage = totalUsage / (usageHistory.length / 24.0);
    final estimatedRemainingDays = totalUsage > 0
        ? (totalUsage / avgDailyUsage).toStringAsFixed(1)
        : 'N/A';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            label: 'Total (24h)',
            value: formatBalanceHours(totalUsage),
            theme: theme,
            colorScheme: colorScheme,
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.onSurface.withOpacity(0.2),
          ),
          _SummaryItem(
            label: 'Avg Daily',
            value: formatBalanceHours(avgDailyUsage),
            theme: theme,
            colorScheme: colorScheme,
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.onSurface.withOpacity(0.2),
          ),
          _SummaryItem(
            label: 'Est. Days',
            value: '$estimatedRemainingDays days',
            theme: theme,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

/// Summary Item widget
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

/// Top-Up Modal Bottom Sheet
class _TopUpModal extends StatefulWidget {
  final double currentBalance;
  final Function(double) onTopUpComplete;

  const _TopUpModal({
    required this.currentBalance,
    required this.onTopUpComplete,
  });

  @override
  State<_TopUpModal> createState() => _TopUpModalState();
}

class _TopUpModalState extends State<_TopUpModal> {
  // Pre-set amounts in HKD (converted to hours: 1 HKD = 1 hour for demo)
  static const List<double> _presetAmounts = [5.0, 10.0, 20.0];
  double? _selectedAmount;
  final TextEditingController _customAmountController = TextEditingController();
  bool _isCustomAmount = false;
  bool _isProcessing = false;
  bool _showPaymentInterface = false;

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  void _selectPresetAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _isCustomAmount = false;
      _customAmountController.clear();
    });
  }

  void _onCustomAmountChanged(String value) {
    setState(() {
      if (value.isNotEmpty) {
        final amount = double.tryParse(value);
        if (amount != null && amount > 0) {
          _selectedAmount = amount;
          _isCustomAmount = true;
        } else {
          _selectedAmount = null;
        }
      } else {
        _selectedAmount = null;
        _isCustomAmount = false;
      }
    });
  }

  void _proceedToPayment() {
    if (_selectedAmount == null || _selectedAmount! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or enter an amount'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _showPaymentInterface = true;
    });
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Convert HKD to hours (1 HKD = 1 hour for demo)
        final topUpHours = _selectedAmount!;
        widget.onTopUpComplete(topUpHours);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Top-up successful! Added ${formatBalanceHours(topUpHours)}',
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void _cancelPayment() {
    setState(() {
      _showPaymentInterface = false;
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: _showPaymentInterface ? 0.7 : 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              if (!_showPaymentInterface) ...[
                // Top-Up Selection View
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Top Up A/C Credit',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current balance: ${formatBalanceHours(widget.currentBalance)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Pre-set Amounts
                      Text(
                        'Quick Top-Up',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _presetAmounts.map((amount) {
                          final isSelected = _selectedAmount == amount && !_isCustomAmount;
                          return InkWell(
                            onTap: () => _selectPresetAmount(amount),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface.withOpacity(0.2),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'HK\$${amount.toStringAsFixed(0)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Custom Amount
                      Text(
                        'Custom Amount',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _customAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: 'Enter amount (HK\$)',
                          prefixText: 'HK\$ ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        onChanged: _onCustomAmountChanged,
                      ),
                      const SizedBox(height: 8),
                      if (_selectedAmount != null && _isCustomAmount)
                        Text(
                          'You will receive ${formatBalanceHours(_selectedAmount!)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      const SizedBox(height: 24),

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
                                'This is a demo top-up. No actual payment will be processed.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Proceed Button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedAmount != null ? _proceedToPayment : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Continue to Payment',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Payment Interface View
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: _cancelPayment,
                                ),
                                Expanded(
                                  child: Text(
                                    'Payment',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 48), // Balance icon button width
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),

                      Expanded(
                        child: _isProcessing
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Processing payment...',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    // Payment Amount
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: colorScheme.onSurface.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Amount',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: colorScheme.onSurface.withOpacity(0.6),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'HK\$${_selectedAmount!.toStringAsFixed(2)}',
                                            style: theme.textTheme.displayMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'You will receive ${formatBalanceHours(_selectedAmount!)}',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: colorScheme.onSurface.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // Payment Methods (Mock)
                                    Text(
                                      'Select Payment Method',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Apple Pay / Google Wallet buttons
                                    _PaymentMethodButton(
                                      icon: Icons.apple,
                                      label: 'Apple Pay',
                                      theme: theme,
                                      colorScheme: colorScheme,
                                      onTap: _processPayment,
                                    ),
                                    const SizedBox(height: 12),
                                    _PaymentMethodButton(
                                      icon: Icons.account_balance_wallet,
                                      label: 'Google Wallet',
                                      theme: theme,
                                      colorScheme: colorScheme,
                                      onTap: _processPayment,
                                    ),
                                    const SizedBox(height: 12),
                                    _PaymentMethodButton(
                                      icon: Icons.credit_card,
                                      label: 'Credit/Debit Card',
                                      theme: theme,
                                      colorScheme: colorScheme,
                                      onTap: _processPayment,
                                    ),
                                    const SizedBox(height: 24),

                                    // Demo Info
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
                                              'This is a demo payment. No actual transaction will occur.',
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
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Payment Method Button Widget
class _PaymentMethodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _PaymentMethodButton({
    required this.icon,
    required this.label,
    required this.theme,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

