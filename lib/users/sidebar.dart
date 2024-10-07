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
      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.5))),
      child: Consumer<SidebarProvider>(
        builder: (context, sidebarProvider, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _buildHeader(sidebarProvider),
              if (!sidebarProvider.isGuestUser)
                _buildListTile(
                  icon: Icons.person,
                  title: 'View Profile',
                  onTap: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                )
              else
                _buildListTile(
                  icon: Icons.person_add,
                  title: 'Sign Up',
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
              _buildListTile(
                icon: Icons.contact_mail,
                title: 'Contact Us',
                onTap: () {
                  Navigator.pushNamed(context, '/contact');
                },
              ),
              _buildListTile(
                icon: Icons.policy,
                title: 'Privacy Policy',
                onTap: () {
                  Navigator.pushNamed(context, '/privacy');
                },
              ),
              _buildListTile(
                icon: Icons.info,
                title: 'Version 1.0.0',
                onTap: () {
                  // Handle version info tap
                },
              ),
              const SizedBox(height: 20), // Add spacing instead of Spacer
              const Divider(), // Optional: Separate the logout button from the rest
              if (!sidebarProvider.isGuestUser)
                _buildLogoutButton(context), // Show logout button only if logged in
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(SidebarProvider sidebarProvider) {
    final profileImagePath = sidebarProvider.profileImagePath;
    ImageProvider<Object> imageProvider;

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

    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.lightBlue],
        ),
      ),
      accountName: Text(
        sidebarProvider.userName,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.brown,
        ),
      ),
      accountEmail: const SizedBox.shrink(), // Optionally display email
      currentAccountPicture: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white, // Optional: Add a white background
        backgroundImage: imageProvider,
        child: profileImagePath.isEmpty
            ? const Icon(Icons.person, size: 0.0001, color: Colors.transparent)
            : null,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onTap: onTap,
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: Colors.blueAccent.withOpacity(0.1),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () => _logout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);

    await FirebaseAuth.instance.signOut();
    sidebarProvider.logout();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', // Replace with the route name of your home screen
      (route) => route.settings.name == '/home',
    );
  }
}
