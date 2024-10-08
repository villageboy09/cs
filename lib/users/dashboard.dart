// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:cropsync/users/sidebar_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _nameController = TextEditingController();
  XFile? _image;
  bool _isEditing = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkUserDocument();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
          await _firestore.collection('users').doc(user.uid).set({
            'name': user.displayName ?? 'User',
            'profileImagePath': '', // Store empty string initially
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

      // Check if name input is not empty and add it to updates
      if (_nameController.text.isNotEmpty) {
        updates['name'] = _nameController.text;
      }

      // Check if image is selected and store its local path in Firestore
      if (_image != null) {
        // Ensure that the path is valid and not null
        String localImagePath = _image!.path;
        updates['profileImagePath'] = localImagePath;
      }

      // Proceed with updating Firestore if there are changes to apply
      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
        await sidebarProvider.updateUserData(); // Update the sidebar provider

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully', style: GoogleFonts.poppins()),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Notify user if there are no changes to update
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No changes to update')),
          );
        }
      }

      // Reset editing state
      setState(() {
        _isEditing = false;
      });
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


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });

      final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);
      await sidebarProvider.updateUserData(); // Update sidebar data after picking an image
    }
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
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          ),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
      final profileImagePath = userData['profileImagePath'] as String? ?? '';
      final userName = userData['name'] as String? ?? '';

      _nameController.text = userName;

      return LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final isWideScreen = maxWidth > 600;
          
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isWideScreen ? 600 : maxWidth * 0.9,
              ),
              padding: EdgeInsets.all(isWideScreen ? 40 : 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Header Section
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: isWideScreen ? 85 : 75,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: isWideScreen ? 80 : 70,
                              backgroundImage: _getProfileImage(profileImagePath),
                              child: (profileImagePath.isEmpty && _image == null)
                                  ? Icon(Icons.person,
                                      size: isWideScreen ? 80 : 70,
                                      color: Colors.grey)
                                  : null,
                            ),
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: isWideScreen ? -20 : -10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.greenAccent, size: 28),
                                onPressed: _pickImage,
                                tooltip: 'Change Profile Picture',
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Name Section
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isEditing
                        ? Container(
                            constraints: BoxConstraints(
                              maxWidth: isWideScreen ? 400 : maxWidth * 0.8,
                            ),
                            child: TextField(
                              controller: _nameController,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: isWideScreen ? 22 : 20,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: isWideScreen ? 16 : 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.greenAccent,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            userName,
                            style: GoogleFonts.poppins(
                              fontSize: isWideScreen ? 32 : 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                  ),

                  // Action Button
                  const SizedBox(height: 32),
                  SizedBox(
                    width: isWideScreen ? 300 : maxWidth * 0.7,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_isEditing) {
                          _updateProfile();
                        }
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _isEditing ? Icons.check_circle : Icons.edit,
                          color: Colors.white,
                          key: ValueKey(_isEditing),
                        ),
                      ),
                      label: Text(
                        _isEditing ? 'Save Changes' : 'Edit Profile',
                        style: GoogleFonts.poppins(
                          fontSize: isWideScreen ? 18 : 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }
      );
    },
  );
}
  ImageProvider? _getProfileImage(String profileImagePath) {
    if (_isEditing && _image != null) {
      return FileImage(File(_image!.path)); // Show selected image if editing
    } else if (profileImagePath.isNotEmpty) {
      return FileImage(File(profileImagePath)); // Use FileImage for local path
    }
    return null; // Return null if no image is available
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
        return Center(
          child: Text(
            'Error loading courses',
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
        );
      }

      final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
      final enrolledCourses = userData['enrolledCourses'] as List<dynamic>? ?? [];

      return Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Enrolled Courses',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (enrolledCourses.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: enrolledCourses.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 16,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  final course = enrolledCourses[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue.shade50,
                    ),
                    child: Text(
                      course.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  );
                },
              )
            else
              Center(
                child: Text(
                  'No enrolled courses yet.',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
}