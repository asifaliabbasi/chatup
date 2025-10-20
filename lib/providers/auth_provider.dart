import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

/// Authentication provider for managing auth state
class AuthProvider extends ChangeNotifier {
  User? _user;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;
  String? _verificationId;

  // Getters
  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get verificationId => _verificationId;
  bool get isAuthenticated => _user != null;

  /// Initialize auth provider
  AuthProvider() {
    _initializeAuth();
  }

  /// Initialize authentication state. Yeh hamara "single source of truth" hai.
  void _initializeAuth() {
    AuthService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        // Jab bhi user sign in hoga, profile yahan se load hogi
        await _loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  /// Load user profile from Firestore
  Future<void> _loadUserProfile() async {
    if (_user == null) return;

    try {
      _userProfile = await AuthService.getUserProfile(_user!.uid);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
    }
  }

  /// Send OTP to phone number
  Future<void> sendOTP(String phoneNumber) async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.sendOTP(
        phoneNumber: phoneNumber,
        onCodeSent: (verificationId) {
          _verificationId = verificationId;
          _setLoading(false);
          // UI is `onCodeSent` ke baad navigate karegi
        },
        onError: (error) {
          _setError(error);
          _setLoading(false);
        },
      );
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Verify OTP code
  Future<bool> verifyOTP(String otpCode) async {
    try {
      _setLoading(true);
      _clearError();

      if (_verificationId == null) {
        _setError('Verification ID not found');
        _setLoading(false);
        return false;
      }

      final userCredential = await AuthService.verifyOTP(
        verificationId: _verificationId!,
        otpCode: otpCode,
      );

      // Agar verification successful hai (userCredential null nahi hai),
      // to _initializeAuth listener khud hi user state update kar dega.
      _setLoading(false);
      return userCredential?.user != null;

    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final userCredential = await AuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setLoading(false);
      return userCredential?.user != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Create account with email and password
  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final userCredential = await AuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setLoading(false);
      return userCredential?.user != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final userCredential = await AuthService.signInWithGoogle();

      _setLoading(false);
      return userCredential?.user != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // --- Baaqi ke functions bilkul theek hain, un mein koi change ki zaroorat nahi ---

  /// Create user profile after successful authentication
  Future<void> createUserProfile({
    required String name,
    required String phone,
    String? email,
    String? profileImageUrl,
    String status = 'Hey there! I am using ChatUp',
    String? bio,
    String? location,
  }) async {
    try {
      if (_user == null) {
        _setError('User not authenticated');
        return;
      }

      await AuthService.createUserProfile(
        uid: _user!.uid,
        name: name,
        phone: phone,
        email: email,
        profileImageUrl: profileImageUrl,
        status: status,
        bio: bio,
        location: location,
      );

      await _loadUserProfile();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? profileImageUrl,
    String? status,
    String? bio,
    String? location,
  }) async {
    try {
      if (_user == null) {
        _setError('User not authenticated');
        return;
      }

      await AuthService.updateUserProfile(
        uid: _user!.uid,
        name: name,
        email: email,
        profileImageUrl: profileImageUrl,
        status: status,
        bio: bio,
        location: location,
      );

      await _loadUserProfile();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Upload profile image
  Future<String?> uploadProfileImage(String imagePath) async {
    try {
      if (_user == null) {
        _setError('User not authenticated');
        return null;
      }

      final imageUrl = await AuthService.uploadProfileImage(
        uid: _user!.uid,
        imagePath: imagePath,
      );

      await updateUserProfile(profileImageUrl: imageUrl);

      return imageUrl;
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.sendPasswordResetEmail(email);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.updatePassword(newPassword);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Delete user account
  Future<void> deleteUserAccount() async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.deleteUserAccount();
      // Listener khud hi _user ko null kar dega
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Update user online status
  Future<void> updateUserOnlineStatus(bool isOnline) async {
    try {
      await AuthService.updateUserOnlineStatus(isOnline);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await AuthService.signOut();
      // Listener khud hi _user, _userProfile, etc. ko null/clear kar dega.
      _verificationId = null;
      _clearError();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error message - YEH PUBLIC HAI
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Private clear error for internal use
  void _clearError() {
    _error = null;
  }

  /// Clear verification ID
  void clearVerificationId() {
    _verificationId = null;
    notifyListeners();
  }
}

