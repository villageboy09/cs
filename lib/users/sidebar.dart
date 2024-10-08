// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cropsync/users/sidebar_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key, required String profileImagePath, required String userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Consumer<SidebarProvider>(
          builder: (context, sidebarProvider, child) {
            return Column(
              children: [
                _buildHeader(sidebarProvider),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          if (!sidebarProvider.isGuestUser)
                            _buildNavItem(
                              context: context,
                              icon: Icons.person,
                              title: 'View Profile',
                              onTap: () => Navigator.pushNamed(context, '/dashboard'),
                            )
                          else
                            _buildNavItem(
                              context: context,
                              icon: Icons.person_add,
                              title: 'Sign Up',
                              onTap: () => Navigator.pushNamed(context, '/signup'),
                            ),
                          _buildNavItem(
                            context: context,
                            icon: Icons.contact_mail,
                            title: 'Contact Us',
                            onTap: () => Navigator.pushNamed(context, '/contact'),
                          ),
                          _buildNavItem(
                            context: context,
                            icon: Icons.policy,
                            title: 'Privacy Policy',
                            onTap: () => Navigator.pushNamed(context, '/privacy'),
                          ),
                          _buildNavItem(
                            context: context,
                            icon: Icons.info,
                            title: 'Version 1.0.0',
                            onTap: () {},
                            isVersion: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!sidebarProvider.isGuestUser) _buildLogoutSection(context),
              ],
            );
          },
        ),
      ),
    );
  }

Widget _buildHeader(SidebarProvider sidebarProvider) {
  final profileImagePath = sidebarProvider.profileImagePath;
  ImageProvider<Object> imageProvider;

  // Determine the image provider based on the path type
  if (profileImagePath.isNotEmpty) {
    if (profileImagePath.startsWith('/data/user') || profileImagePath.startsWith('file://')) {
      final file = File(profileImagePath.startsWith('file://')
          ? profileImagePath.replaceFirst('file://', '')
          : profileImagePath);
      imageProvider = FileImage(file);
    } else if (profileImagePath.startsWith('http://') || profileImagePath.startsWith('https://')) {
      imageProvider = NetworkImage(profileImagePath);
    } else {
      imageProvider = const AssetImage('assets/S.png');
    }
  } else {
    imageProvider = const AssetImage('assets/S.png');
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blue.shade800, Colors.blue.shade400],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 42,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: imageProvider,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          sidebarProvider.userName,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isVersion = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isVersion ? Colors.transparent : Colors.blue.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isVersion ? Colors.grey : Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isVersion ? Colors.grey : Colors.black87,
                    fontWeight: isVersion ? FontWeight.normal : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _logout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 20),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);

    await FirebaseAuth.instance.signOut();
    sidebarProvider.logout();

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          'Logged out successfully',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => route.settings.name == '/home',
    );
  }
}