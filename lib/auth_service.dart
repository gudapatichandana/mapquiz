import 'user_model.dart';
import 'local_storage_service.dart';

class AuthService {
  final LocalStorageService _storageService = LocalStorageService();
  static const String _currentUserKey = 'current_user';

  Future<void> init() async {
    await _storageService.init();
  }

  // Simulate user login (for offline app)
  Future<UserModel?> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    try {
      // For offline app, we'll create a demo user or use stored one
      final existingUser = await getCurrentUser();
      if (existingUser != null && existingUser.email == email) {
        // Update last login
        final updatedUser = existingUser.copyWith(
          lastLoginAt: DateTime.now(),
        );
        await _storageService.setString(_currentUserKey, updatedUser.id);
        await _storageService.saveUser(updatedUser);
        return updatedUser;
      }
      
      // Create new demo user
      final newUser = UserModel(
        id: _generateUserId(),
        email: email,
        name: _getNameFromEmail(email),
        lastLoginAt: DateTime.now(),
      );
      
      await _storageService.setString(_currentUserKey, newUser.id);
      await _storageService.saveUser(newUser);
      return newUser;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Simulate user registration
  Future<UserModel?> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      final newUser = UserModel(
        id: _generateUserId(),
        email: email,
        name: name,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      await _storageService.setString(_currentUserKey, newUser.id);
      await _storageService.saveUser(newUser);
      return newUser;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = _storageService.getCurrentUserId();
      if (userId == null || userId.isEmpty) return null;
      
      return _storageService.getUser(userId);
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _storageService.clearCurrentUser();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Reset password (simulated for offline)
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Always return true for offline app
  }

  // Update user
  Future<bool> updateUser(UserModel user) async {
    try {
      await _storageService.saveUser(user);
      return true;
    } catch (e) {
      print('Update user error: $e');
      return false;
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser != null) {
        await _storageService.deleteUser(currentUser.id);
      }
      await signOut();
      return true;
    } catch (e) {
      print('Delete account error: $e');
      return false;
    }
  }

  // Helper methods
  String _generateUserId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _getNameFromEmail(String email) {
    final namePart = email.split('@').first;
    return namePart.split('.').map((part) => 
      part[0].toUpperCase() + part.substring(1)
    ).join(' ');
  }
}