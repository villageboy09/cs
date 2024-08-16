import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;
  
Future<void> signIn(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    _user = userCredential.user;
    notifyListeners();
  } on FirebaseAuthException {
    // Rethrow the caught exception to be handled in the calling context
    rethrow; // Use rethrow to maintain the stack trace
  }
}
  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException {
      // Rethrow the exception to be handled in the calling context
      rethrow;
    } catch (e) {
      // Handle any other exceptions
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}