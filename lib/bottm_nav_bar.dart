// ignore_for_file: library_private_types_in_public_api

import 'package:cropsync/current_affairs.dart';
import 'package:cropsync/markets_prices/mandi_prices.dart';
import 'package:cropsync/products/catologue.dart';
import 'package:flutter/material.dart';
import 'package:cropsync/home_page.dart';
import 'package:cropsync/crop_advisory/advisory.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavbarPage extends StatefulWidget {
  const BottomNavbarPage({Key? key}) : super(key: key);

  @override
  _BottomNavbarPageState createState() => _BottomNavbarPageState();
}

class _BottomNavbarPageState extends State<BottomNavbarPage> {
  int _selectedIndex = 2; // Default selected index
  final List<Widget> _pages = const [
    CropAdvisoryPage(),
    MandiPrices(),
    HomePage(),
    ProductCatalogPage(),
    CurrentAffairsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 2, // Allow popping only when on the Home page
      onPopInvoked: (didPop) {
        if (!didPop) {
          setState(() {
            _selectedIndex = 2; // Navigate back to the home page
          });
        }
      },
      child: Scaffold(
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index; // Update the selected index
            });
          },
          items: [
            /// Advisory Tab
            SalomonBottomBarItem(
              unselectedColor: Colors.teal.shade300,
              icon: const Icon(Icons.people),
              title: Text("Advisory", style: GoogleFonts.poppins()),
              selectedColor: Colors.green,
            ),

            /// Mandi Tab
            SalomonBottomBarItem(
              unselectedColor: Colors.teal.shade300,
              icon: const Icon(Icons.shopping_cart),
              title: Text("Mandi", style: GoogleFonts.poppins()),
              selectedColor: Colors.green,
            ),

            /// Home Tab
            SalomonBottomBarItem(
              unselectedColor: Colors.teal.shade300,
              icon: const Icon(Icons.home),
              title: Text("Home", style: GoogleFonts.poppins()),
              selectedColor: Colors.green,
            ),

            /// Shop Tab
            SalomonBottomBarItem(
              unselectedColor: Colors.teal.shade300,
              icon: const Icon(Icons.store),
              title: Text("Shop", style: GoogleFonts.poppins()),
              selectedColor: Colors.green,
            ),

            /// News Tab
            SalomonBottomBarItem(
              unselectedColor: Colors.teal.shade300,
              icon: const Icon(Icons.article),
              title: Text("News", style: GoogleFonts.poppins()),
              selectedColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
