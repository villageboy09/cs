// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SidebarProvider with ChangeNotifier {
  String _profileImageUrl = '';
  String _userName = 'Guest';
  bool _isLoading = true;

  String get profileImageUrl => _profileImageUrl;
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
    notifyListeners();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user data from Firestore
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        
        DocumentSnapshot userDataSnapshot = await userRef.get();

        if (userDataSnapshot.exists) {
          // Check and retrieve profile image and name from Firestore
          Map<String, dynamic>? userData = userDataSnapshot.data() as Map<String, dynamic>?;

          _profileImageUrl = userData?['profileImageUrl'] ?? '';
          _userName = userData?['name'] ?? 'User';
          print('Fetched user data - Name: $_userName, Image: $_profileImageUrl'); // Debug log
        } else {
          print('User data not found in Firestore'); // Debug log
          _profileImageUrl = '';
          _userName = 'User';
        }
      } else {
        print('No current user found'); // Debug log
        _profileImageUrl = '';
        _userName = 'Guest';
      }
    } catch (e) {
      print('Error updating user data: $e');
      _userName = 'Guest';
      _profileImageUrl = '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _profileImageUrl = '';
    _userName = 'Guest';
    _isLoading = false;
    notifyListeners();
  }
}
