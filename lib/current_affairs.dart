// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shimmer/shimmer.dart';

class CurrentAffairsPage extends StatefulWidget {
  const CurrentAffairsPage({Key? key}) : super(key: key);

  @override
  _CurrentAffairsPageState createState() => _CurrentAffairsPageState();
}

class _CurrentAffairsPageState extends State<CurrentAffairsPage> {
  late final String announcementsSheetId;
  late final Map<String, dynamic> credentials;
  late final GSheets gsheets;
  late Worksheet? gsheetCrudCurrentAffairs;
  List<Map<String, String>>? announcementsRows;

  @override
  void initState() {
    super.initState();

    // Access the credentials and sheet ID from environment variables
    announcementsSheetId = dotenv.env['ANNOUNCEMENTS_SHEET_ID']!;
    
    // Parse the credentials JSON string into a Map
    credentials = dotenv.env['GSHEETS_CREDENTIALS'] != null
        ? Map<String, dynamic>.from(json.decode(dotenv.env['GSHEETS_CREDENTIALS']!))
        : {};

    gsheets = GSheets(credentials);
    fetchCurrentAffairs();
  }
  Future<void> fetchCurrentAffairs() async {
    try {
      final controller = await gsheets.spreadsheet(announcementsSheetId);
      gsheetCrudCurrentAffairs = controller.worksheetByTitle('Sheet1');
      announcementsRows = await gsheetCrudCurrentAffairs?.values.map.allRows();
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to fetch data. Pull down to try again.',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        title: Text('Daily Current Affairs',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w800)),
        actions: [
          Image.asset(
            'assets/S.png',
            width: 48, // Adjust the width as needed
            height: 48, // Adjust the height as needed
          ),
        ],
      ),
      drawer: const Sidebar(profileImageUrl: '', userName: ''),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchCurrentAffairs,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: announcementsRows == null
                    ? _buildShimmerEffect()
                    : _buildCurrentAffairsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentAffairsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: announcementsRows!.length,
      itemBuilder: (BuildContext context, int index) {
        final row = announcementsRows![index];
        return _buildAnnouncementCard(row);
      },
    );
  }

  Widget _buildAnnouncementCard(Map<String, String> row) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: row['Image URL'] != null && row['Image URL']!.isNotEmpty
                  ? Image.network(
                      row['Image URL']!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Image.asset(
                          'assets/S.png', // Replace with the actual path to your logo file
                          height: 300, // Adjust the size as needed
                          width: 300,
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row['Title'] ?? 'No Title',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  row['Description'] ?? 'No Description',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
