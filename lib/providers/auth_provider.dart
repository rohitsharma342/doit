import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../data/static_data.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isOfficial => _currentUser?.isOfficial ?? false;
  bool get isStartup => _currentUser?.isStartup ?? false;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = StaticData.users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('Invalid credentials'),
      );

      if (password.length < 6) {
        throw Exception('Invalid credentials');
      }

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String startupName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final existingUser = StaticData.users.any(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      if (existingUser) {
        throw Exception('Email already registered');
      }

      final newUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: startupName,
        email: email,
        role: UserRole.startup,
        createdAt: DateTime.now(),
      );

      StaticData.users.add(newUser);
      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}