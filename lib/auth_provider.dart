import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'auth_service.dart';
import 'local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  bool _isDisposed = false;
  
  AuthProvider() : _authService = AuthService() {
    _initialize();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> _initialize() async {
    try {
      await _authService.init();
      await _loadCurrentUser();
    } catch (e) {
      _error = 'Failed to initialize authentication: $e';
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      _isLoading = true;
      _error = null;
      _safeNotifyListeners();

      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        _user = currentUser;
        _isAuthenticated = true;
      } else {
        _user = null;
        _isAuthenticated = false;
      }
    } catch (e) {
      _error = 'Failed to load user: $e';
      _user = null;
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  UserModel? _user;
  bool _isLoading = true;
  String? _error;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      _safeNotifyListeners();

      final user = await _authService.signIn(email, password);
      if (user != null) {
        _user = user;
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = null;
      _safeNotifyListeners();

      final user = await _authService.signUp(email, password, name);
      if (user != null) {
        _user = user;
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = 'Failed to sign out: $e';
    } finally {
      _safeNotifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      _safeNotifyListeners();

      final success = await _authService.resetPassword(email);
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      final success = await _authService.updateUser(user);
      if (success) {
        _user = user;
        _safeNotifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to update user: $e';
      return false;
    }
  }

  Future<bool> updateProfile({String? name, String? profilePicture}) async {
    try {
      if (_user == null) return false;

      final updatedUser = _user!.copyWith(
        name: name ?? _user!.name,
        profilePicture: profilePicture ?? _user!.profilePicture,
      );

      final success = await updateUser(updatedUser);
      return success;
    } catch (e) {
      _error = 'Failed to update profile: $e';
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final success = await _authService.deleteAccount();
      if (success) {
        _user = null;
        _isAuthenticated = false;
        _error = null;
      }
      return success;
    } catch (e) {
      _error = 'Failed to delete account: $e';
      return false;
    } finally {
      _safeNotifyListeners();
    }
  }

  void clearError() {
    _error = null;
    _safeNotifyListeners();
  }

  void refreshUser() {
    _loadCurrentUser();
  }
}