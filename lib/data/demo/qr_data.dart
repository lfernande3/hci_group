/// Demo QR code data for CityU ID
class QrCodeData {
  final String studentId;
  final String studentName;
  final String email;
  final String program;
  final String qrCodeValue;
  final DateTime expiryDate;

  const QrCodeData({
    required this.studentId,
    required this.studentName,
    required this.email,
    required this.program,
    required this.qrCodeValue,
    required this.expiryDate,
  });

  /// Get demo QR code data
  static QrCodeData getDemoQrCode() {
    return QrCodeData(
      studentId: '12345678',
      studentName: 'John Doe',
      email: 'john.doe@cityu.edu.hk',
      program: 'BSc Computer Science',
      qrCodeValue: 'CITYUHK|12345678|JOHN_DOE|2024/25|SEMESTER_A',
      expiryDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  /// Check if QR code is expired
  bool get isExpired => DateTime.now().isAfter(expiryDate);

  /// Get formatted expiry date
  String get formattedExpiryDate {
    return '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
  }
}

