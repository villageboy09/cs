
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cropsync/users/sidebar_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar(
      {Key? key, required String profileImageUrl, required String userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            ],
          );
        },
      ),
    );
  }

Widget _buildHeader(SidebarProvider sidebarProvider) {
  final profileImageUrl = sidebarProvider.profileImageUrl;
  ImageProvider<Object> imageProvider;

  if (profileImageUrl.isNotEmpty) {
    if (profileImageUrl.startsWith('/data/user') || profileImageUrl.startsWith('file://')) {
      // Handle local file path
      final file = File(profileImageUrl.startsWith('file://') 
          ? profileImageUrl.replaceFirst('file://', '') 
          : profileImageUrl);
      imageProvider = FileImage(file);
    } else if (profileImageUrl.startsWith('http://') || profileImageUrl.startsWith('https://')) {
      // Handle network URL
      imageProvider = NetworkImage(profileImageUrl);
    } else {
      // Fallback to asset image if the URL is neither a file path nor a network URL
      imageProvider = const AssetImage('assets/S.png');
    }
  } else {
    // Default image if no URL
    imageProvider = const AssetImage('assets/S.png');
  }

  return UserAccountsDrawerHeader(
    decoration: const BoxDecoration(
      color: Colors.blueAccent,
    ),
    accountName: Text(
      sidebarProvider.userName,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    accountEmail: const Text(''), // Optionally display email
    currentAccountPicture: CircleAvatar(
      backgroundImage: imageProvider,
      child: profileImageUrl.isEmpty
          ? const Icon(Icons.person, size: 0.000001, color: Colors.transparent)
          : null,
    ),
  );
}


  Widget _buildListTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
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
}
