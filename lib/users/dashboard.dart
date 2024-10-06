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
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading profile', style: GoogleFonts.poppins(color: Colors.red)));
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final profileImageUrl = userData?['profileImageUrl'];
        final userName = userData?['name'] ?? '';

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
                        ? const Icon(Icons.person, size: 0.0001, color: Colors.transparent)
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
                icon: Icon(_isEditing ? Icons.save : Icons.edit,color: Colors.black,),
                label: Text(_isEditing ? 'Save Profile' : 'Edit Profile',style: GoogleFonts.poppins(fontSize: 16,color: Colors.black),),
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
    } else if (profileImageUrl != null) {
      return FileImage(File(profileImageUrl));
    }
    return null;
  }

  Widget _buildEnrolledCoursesSection() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading courses', style: GoogleFonts.poppins(color: Colors.red)));
        }

        final userData = snapshot.data?.data() as Map?;
        final enrolledCourses = List.from(userData?['enrolledCourses'] ?? []);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Enrolled Courses',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              if (enrolledCourses.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: enrolledCourses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildCourseCard(enrolledCourses[index]);
                  },
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No courses enrolled yet.',
                      style: GoogleFonts.poppins(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCourseCard(String course) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(course, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
        onTap: () {
          if (course == 'Crop Consultant/Agronomist') {
            Navigator.pushReplacementNamed(context, '/agronomistCourse');
          } else if (course == 'Supply Chain Manager in Agriculture') {
            Navigator.pushReplacementNamed(context, '/supplyChainCourse');
          }
        },
      ),
    );
  }
}