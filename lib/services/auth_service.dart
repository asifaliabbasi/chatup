import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';
import 'storage_service.dart';

/// Comprehensive authentication service
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Send OTP to phone number
  static Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sending OTP: $e');
      }
      onError(e.toString());
    }
  }

  /// Verify OTP code
  static Future<UserCredential?> verifyOTP({
    required String verificationId,
    required String otpCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying OTP: $e');
      }
      rethrow;
    }
  }

  /// Sign in with email and password
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with email: $e');
      }
      rethrow;
    }
  }

  /// Create account with email and password
  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user with email: $e');
      }
      rethrow;
    }
  }

  /// Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }
      rethrow;
    }
  }

  /// Create user profile in Firestore
  static Future<void> createUserProfile({
    required String uid,
    required String name,
    required String phone,
    String? email,
    String? profileImageUrl,
    String status = 'Hey there! I am using ChatUp',
    String? bio,
    String? location,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        name: name,
        phone: phone,
        email: email ?? '',
        profileImageUrl: profileImageUrl ?? '',
        status: status,
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        bio: bio,
        location: location,
      );

      await FirestoreService.createUserProfile(userModel);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user profile: $e');
      }
      rethrow;
    }
  }

  /// Update user profile
  static Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? email,
    String? profileImageUrl,
    String? status,
    String? bio,
    String? location,
  }) async {
    try {
      await FirestoreService.updateUserProfile(
        uid: uid,
        name: name,
        email: email,
        profileImageUrl: profileImageUrl,
        status: status,
        bio: bio,
        location: location,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user profile: $e');
      }
      rethrow;
    }
  }

  /// Upload profile image
  static Future<String?> uploadProfileImage({
    required String uid,
    required String imagePath,
  }) async {
    try {
      return await StorageService.uploadProfileImage(
        uid: uid,
        imagePath: imagePath,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image: $e');
      }
      return null;
    }
  }

  /// Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print('Error sending password reset email: $e');
      }
      rethrow;
    }
  }

  /// Update password
  static Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating password: $e');
      }
      rethrow;
    }
  }

  /// Delete user account
  static Future<void> deleteUserAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await FirestoreService.deleteUserProfile(user.uid);

        // Delete user account
        await user.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user account: $e');
      }
      rethrow;
    }
  }

  /// Get current user
  static User? get currentUser => _auth.currentUser;

  /// Check if user is authenticated
  static bool get isAuthenticated => _auth.currentUser != null;

  /// Sign out user
  static Future<void> signOut() async {
    try {
      // Update online status to false
      final user = _auth.currentUser;
      if (user != null) {
        await FirestoreService.updateUserOnlineStatus(user.uid, false);
      }

      // Sign out from Firebase Auth
      await _auth.signOut();

      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      rethrow;
    }
  }

  /// Listen to auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get user profile from Firestore
  static Future<UserModel?> getUserProfile(String uid) async {
    try {
      return await FirestoreService.getUserProfile(uid);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user profile: $e');
      }
      return null;
    }
  }

  /// Update user online status
  static Future<void> updateUserOnlineStatus(bool isOnline) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await FirestoreService.updateUserOnlineStatus(user.uid, isOnline);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating online status: $e');
      }
    }
  }
}
