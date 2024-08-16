// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cropsync/users/sidebar_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _nameController = TextEditingController();
  XFile? _image;
  bool _isEditing = false; // State variable to track edit mode

  @override
  void initState() {
    super.initState();
    _checkUserDocument(); // Check if user document exists on init
  }

  Future<void> _checkUserDocument() async {
    final sidebarProvider =
        Provider.of<SidebarProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (!doc.exists) {
          // Create a new user document if it doesn't exist
          await docRef.set({
            'name': user.displayName ?? 'User',
            'profileImageUrl': '',
            // Add other default fields as necessary
          });
        }

        // After creating or confirming the document, update the SidebarProvider
        await sidebarProvider.updateUserData();
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }

  Future<void> _updateProfile() async {
    final sidebarProvider =
        Provider.of<SidebarProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic> updates = {};

      if (_nameController.text.isNotEmpty) {
        updates['name'] = _nameController.text;
      }

      if (_image != null) {
        updates['profileImageUrl'] = _image?.path;
      }

      if (updates.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(updates, SetOptions(merge: true));

        await sidebarProvider.updateUserData(); // Inform the SidebarProvider

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        setState(() {
          _isEditing = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes to update')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        // Update SidebarProvider with new image URL if needed
        final sidebarProvider =
            Provider.of<SidebarProvider>(context, listen: false);
        sidebarProvider.updateUserData(); // Update user data with new image URL
      }
    });
  }

  Future<void> _logout() async {
    final sidebarProvider =
        Provider.of<SidebarProvider>(context, listen: false);

    await FirebaseAuth.instance.signOut();
    sidebarProvider.logout(); // Inform the SidebarProvider of the logout action

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', // Replace with the route name of your home screen
      (route) =>
          route.settings.name ==
          '/home', // Replace with the route name of your home screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 32.0),
            _buildEnrolledCoursesSection(),
            const Spacer(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error loading profile');
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final profileImageUrl = userData?['profileImageUrl'];
        final userName = userData?['name'] ?? '';

        // Pre-fill the name controller with the existing name
        _nameController.text = userName;

        return Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _isEditing
                      ? (_image != null
                          ? FileImage(File(_image!.path))
                          : (profileImageUrl != null
                              ? FileImage(File(profileImageUrl))
                              : null))
                      : (profileImageUrl != null
                          ? FileImage(File(profileImageUrl))
                          : null),
                  child: (profileImageUrl == null && _image == null)
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _pickImage,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            _isEditing
                ? TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    userName,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_isEditing) {
                  _updateProfile(); // Save changes
                }
                setState(() {
                  _isEditing = !_isEditing; // Toggle between edit and view mode
                });
              },
              child: Text(_isEditing ? 'Update Profile' : 'Edit Profile'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEnrolledCoursesSection() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error loading courses');
        }

        final userData = snapshot.data?.data() as Map?;
        final enrolledCourses = List.from(userData?['enrolledCourses'] ?? []);

        if (enrolledCourses.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Enrolled Courses:'),
              const SizedBox(height: 8.0),
              ...enrolledCourses.map((course) {
                return ElevatedButton(
                  onPressed: () {
                    if (course == 'Crop Consultant/Agronomist') {
                      Navigator.pushReplacementNamed(context,
                          '/agronomistCourse'); // Update with actual route
                    } else if (course ==
                        'Supply Chain Manager in Agriculture') {
                      Navigator.pushReplacementNamed(context,
                          '/supplyChainCourse'); // Update with actual route
                    }
                  },
                  child: Text(course),
                );
              }).toList(),
            ],
          );
        } else {
          return const Text('No courses enrolled yet.');
        }
      },
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Set the color of the logout button
      ),
      child: Text('Logout',
          style: GoogleFonts.poppins(), selectionColor: Colors.black),
    );
  }
}
