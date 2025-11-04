import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/check_login_status_usecase.dart';

/// User state provider
class UserProvider extends ChangeNotifier {
  final CheckLoginStatusUseCase checkLoginStatusUseCase;

  UserProvider({required this.checkLoginStatusUseCase});

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user?.isLoggedIn ?? false;

  /// Initialize user state
  Future<void> initialize() async {
    _setLoading(true);
    
    final result = await checkLoginStatusUseCase.getCurrentUser();
    result.fold(
      (failure) => _setError(failure.message),
      (user) => _setUser(user),
    );
    
    _setLoading(false);
  }

  /// Get user display name
  String get displayName {
    if (_user?.isLoggedIn == true) {
      return _user!.fullName;
    }
    return 'Log In';
  }

  /// Check if user needs to log in
  bool get needsLogin => !isLoggedIn;

  /// Update user
  void updateUser(User user) {
    _setUser(user);
  }

  /// Logout user
  void logout() {
    _setUser(User.loggedOut());
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setUser(User? user) {
    _user = user;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }
}
