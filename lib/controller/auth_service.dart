import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Key for storing user login state in SharedPreferences
  static const String _loggedInKey = 'loggedIn';

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Method to handle user login
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save login state to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(_loggedInKey, true);

      return result.user;
    } catch (error) {
      print('Error logging in: $error');
      return null;
    }
  }

  // Method to handle user logout
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      // Clear login state in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(_loggedInKey, false);
    } catch (error) {
      print('Error logging out: $error');
    }
  }
}
