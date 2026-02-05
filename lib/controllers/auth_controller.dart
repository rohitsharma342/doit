import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/static_data_service.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isStartup => _currentUser?.isStartup ?? false;
  bool get isOfficial => _currentUser?.isOfficial ?? false;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    clearError();

    await Future.delayed(const Duration(seconds: 1));

    final user = StaticDataService.authenticateUser(email, password);
    if (user != null) {
      _currentUser = user;
      setLoading(false);
      return true;
    } else {
      _errorMessage = 'Invalid email or password';
      setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String startupName,
    required String email,
    required String password,
  }) async {
    setLoading(true);
    clearError();

    await Future.delayed(const Duration(seconds: 1));

    if (StaticDataService.emailExists(email)) {
      _errorMessage = 'Email already registered';
      setLoading(false);
      return false;
    }

    _currentUser = UserModel(
      id: 'new_user_${DateTime.now().millisecondsSinceEpoch}',
      name: startupName,
      email: email,
      role: UserRole.startup,
      companyName: startupName,
      createdAt: DateTime.now(),
    );

    setLoading(false);
    return true;
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void loginAsOfficial() {
    _currentUser = StaticDataService.getOfficialUser();
    notifyListeners();
  }

  void loginAsStartup() {
    _currentUser = StaticDataService.getStartupUser();
    notifyListeners();
  }
}
