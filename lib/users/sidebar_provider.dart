// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SidebarProvider with ChangeNotifier {
  String _profileImagePath = '';
  String _userName = 'Guest';
  bool _isLoading = true;
  bool _isDisposed = false;

  String get profileImagePath => _profileImagePath;
  String get userName => _userName;
  bool get isLoading => _isLoading;
  bool get isGuestUser => _userName == 'Guest';

  SidebarProvider() {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    await _updateUserData();
  }

  Future<void> updateUserData() async {
    await _updateUserData();
  }

  Future<void> _updateUserData() async {
    _isLoading = true;
    _notifyListenersSafely();

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        DocumentSnapshot userDataSnapshot = await userRef.get();

        if (userDataSnapshot.exists) {
          Map<String, dynamic>? userData = userDataSnapshot.data() as Map<String, dynamic>?;

          _profileImagePath = userData?['profileImagePath'] ?? '';
          _userName = userData?['name'] ?? 'User';

          print('Fetched user data - Name: $_userName, Image: $_profileImagePath');
        } else {
          print('User data not found in Firestore');
          _profileImagePath = '';
          _userName = 'User';
        }
      } else {
        print('No current user found');
        _profileImagePath = '';
        _userName = 'Guest';
      }
    } catch (e) {
      print('Error updating user data: $e');
      _profileImagePath = '';
      _userName = 'Guest';
    } finally {
      // Ensure to only notify if not disposed
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void logout() {
    _profileImagePath = '';
    _userName = 'Guest';
    _isLoading = false;
    _notifyListenersSafely();
  }

  void _notifyListenersSafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed
    super.dispose(); // Call super.dispose()
  }
}