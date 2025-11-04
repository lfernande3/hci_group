import 'package:equatable/equatable.dart';

/// User domain entity
class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? studentId;
  final bool isLoggedIn;
  final String? profileImageUrl;
  final UserType userType;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.studentId,
    required this.isLoggedIn,
    this.profileImageUrl,
    required this.userType,
  });

  /// Create a logged-out user
  factory User.loggedOut() {
    return const User(
      id: '',
      email: '',
      fullName: 'Guest User',
      isLoggedIn: false,
      userType: UserType.guest,
    );
  }

  /// Copy with new values
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? studentId,
    bool? isLoggedIn,
    String? profileImageUrl,
    UserType? userType,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        studentId,
        isLoggedIn,
        profileImageUrl,
        userType,
      ];
}

/// User type enumeration
enum UserType {
  student,
  staff,
  visitor,
  guest,
}
