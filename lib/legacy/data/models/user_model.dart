import '../../domain/entities/user.dart';

/// User data model for serialization/deserialization
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.studentId,
    required super.isLoggedIn,
    super.profileImageUrl,
    required super.userType,
  });

  /// Create from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      studentId: user.studentId,
      isLoggedIn: user.isLoggedIn,
      profileImageUrl: user.profileImageUrl,
      userType: user.userType,
    );
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      studentId: json['studentId'],
      isLoggedIn: json['isLoggedIn'] ?? false,
      profileImageUrl: json['profileImageUrl'],
      userType: UserType.values.firstWhere(
        (type) => type.name == json['userType'],
        orElse: () => UserType.guest,
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'studentId': studentId,
      'isLoggedIn': isLoggedIn,
      'profileImageUrl': profileImageUrl,
      'userType': userType.name,
    };
  }

  /// Create logged-out user model
  factory UserModel.loggedOut() {
    return const UserModel(
      id: '',
      email: '',
      fullName: 'Guest User',
      isLoggedIn: false,
      userType: UserType.guest,
    );
  }

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      studentId: studentId,
      isLoggedIn: isLoggedIn,
      profileImageUrl: profileImageUrl,
      userType: userType,
    );
  }

  /// Copy with new values
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? studentId,
    bool? isLoggedIn,
    String? profileImageUrl,
    UserType? userType,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
    );
  }
}
