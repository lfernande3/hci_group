/// Utility for checking NFC availability
/// For demo purposes, this is a mock implementation
/// In production, this would use platform-specific NFC APIs
class NFCAvailabilityChecker {
  /// Check if NFC is available on the device
  /// Returns a Future that resolves to true if NFC is available, false otherwise
  /// 
  /// For demo: Simulates checking NFC availability
  /// In production, this would check:
  /// - If device has NFC hardware
  /// - If NFC is enabled in system settings
  /// - If app has NFC permissions
  static Future<bool> isNFCAvailable() async {
    // Simulate async check (like a real API call)
    await Future.delayed(const Duration(milliseconds: 300));
    
    // For demo: Return true by default (NFC available)
    // In a real app, this would check actual NFC availability
    // Example: return await NfcManager.instance.isAvailable();
    return true;
  }

  /// Check if NFC is enabled (not just available)
  /// In production, this would check system settings
  static Future<bool> isNFCEnabled() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // For demo: Return true by default
    // In production: Check system NFC settings
    return true;
  }

  /// Get a user-friendly error message if NFC is not available
  static String getUnavailableMessage() {
    return 'NFC is not available on this device. Please use a device with NFC support to register visitors.';
  }

  /// Get a user-friendly error message if NFC is not enabled
  static String getDisabledMessage() {
    return 'NFC is disabled. Please enable NFC in your device settings to register visitors.';
  }
}

