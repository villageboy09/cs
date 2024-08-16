// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cropsync/users/auth_provider.dart' as custom_auth; // Alias the custom AuthProvider
import 'package:cropsync/users/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'course_card.dart'; // Import the course card widget

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  Future<List<String>> _getEnrolledCourses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      return List<String>.from(userData?['enrolledCourses'] ?? []);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<custom_auth.AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'Courses',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: const Sidebar(profileImageUrl: '', userName: ''),

      body: FutureBuilder<List<String>>(
        future: _getEnrolledCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final enrolledCourses = snapshot.data ?? [];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('courses').snapshots(),
            builder: (context, courseSnapshot) {
              if (courseSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (courseSnapshot.hasError) {
                return Center(child: Text('Error: ${courseSnapshot.error}'));
              }
              if (!courseSnapshot.hasData || courseSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No courses available.'));
              }

              final courses = courseSnapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'imageUrl': data['imageUrl'] ?? '',
                  'title': data['title'] ?? '',
                  'description': data['description'] ?? '',
                  'price': data['price'] ?? '',
                };
              }).toList();

              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseCard(
                    imageUrl: course['imageUrl']!,
                    title: course['title']!,
                    description: course['description']!,
                    price: course['price']!,
                    enrolledCourses: enrolledCourses,
                    onRequestPressed: () {
                      print('Request pressed for ${course['title']}');
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
