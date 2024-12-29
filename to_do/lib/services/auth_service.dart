import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance
  User? get user => _auth.currentUser; // Getter for the currently signed-in user

  // Login method using email and password
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password); // Firebase sign-in
      notifyListeners(); // Notify listeners to update UI after login
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e.code); // Handle Firebase-specific errors
    } catch (_) {
      throw 'An unexpected error occurred. Please try again.'; // General error handling
    }
  }

  // Register method for creating new user accounts
  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password); // Firebase account creation
      notifyListeners(); // Notify listeners after account registration
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e.code); // Handle Firebase-specific errors
    } catch (_) {
      throw 'An unexpected error occurred. Please try again.'; // General error handling
    }
  }

  // Logout method to sign out the current user
  Future<void> logout() async {
    try {
      await _auth.signOut(); // Firebase sign-out
      notifyListeners(); // Notify listeners after logout
    } catch (_) {
      throw 'Failed to logout. Please try again.'; // Error handling for sign-out
    }
  }

  // Helper method to get user-friendly error messages
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'weak-password':
        return 'Your password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
