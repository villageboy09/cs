// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cropsync/users/sidebar_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Changed to Firestore

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _nameController = TextEditingController();
  XFile? _image;
  bool _isEditing = false;
  
  // Initialize Firestore and Firebase Storage
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _checkUserDocument();
  }

  Future<void> _checkUserDocument() async {
    final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          await sidebarProvider.updateUserData();
        } else {
          // Create new user document if it doesn't exist
          await _firestore.collection('users').doc(user.uid).set({
            'name': user.displayName ?? 'User',
            'profileImageUrl': '',
            'enrolledCourses': [],
            'createdAt': FieldValue.serverTimestamp(),
          });
          print('New user created in Firestore: ${user.uid}');
          await sidebarProvider.updateUserData();
        }
      } catch (e) {
        print('Error checking/updating user document: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error connecting to database: $e')),
          );
        }
      }
    }
  }

  Future<void> _updateProfile() async {
    final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        Map<String, dynamic> updates = {};

        if (_nameController.text.isNotEmpty) {
          updates['name'] = _nameController.text;
        }

        // Upload the image to Firebase Storage if selected
        if (_image != null) {
          final imageUrl = await _uploadImage(_image!);
          updates['profileImageUrl'] = imageUrl;
        }

        if (updates.isNotEmpty) {
          await _firestore.collection('users').doc(user.uid).update(updates);
          await sidebarProvider.updateUserData();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }

          setState(() {
            _isEditing = false;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No changes to update')),
            );
          }
        }
      } catch (e) {
        print('Error updating profile: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e')),
          );
        }
      }
    }
  }

  Future<String> _uploadImage(XFile image) async {
    try {
      final fileName = '${FirebaseAuth.instance.currentUser!.uid}/profileImage/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child(fileName);

      // Upload the image file
      await storageRef.putFile(File(image.path));
      
      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      print('Image uploaded to Firebase Storage, URL: $downloadUrl'); // Debug log
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow; // Rethrow the error to be caught in _updateProfile
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);
        sidebarProvider.updateUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Dashboard', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[50],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 24),
            _buildEnrolledCoursesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading profile', style: GoogleFonts.poppins(color: Colors.red)));
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final profileImageUrl = userData?['profileImageUrl'] as String?;
        final userName = userData?['name'] as String? ?? '';

        _nameController.text = userName;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _getProfileImage(profileImageUrl),
                    child: (profileImageUrl == null && _image == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.green),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _isEditing
                  ? TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    )
                  : Text(
                      userName,
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (_isEditing) {
                    _updateProfile();
                  }
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.black),
                label: Text(_isEditing ? 'Save Profile' : 'Edit Profile', 
                     style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider? _getProfileImage(String? profileImageUrl) {
    if (_isEditing && _image != null) {
      return FileImage(File(_image!.path));
    } else if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      return NetworkImage(profileImageUrl); // Use NetworkImage for URLs
    }
    return null;
  }

  Widget _buildEnrolledCoursesSection() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading courses', style: GoogleFonts.poppins(color: Colors.red)));
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final enrolledCourses = userData?['enrolledCourses'] as List<dynamic>? ?? [];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enrolled Courses', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: enrolledCourses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      enrolledCourses[index].toString(),
                      style: GoogleFonts.poppins(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
