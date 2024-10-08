// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cropsync/users/sidebar.dart';

class CurrentAffairsPage extends StatefulWidget {
  const CurrentAffairsPage({Key? key}) : super(key: key);

  @override
  _CurrentAffairsPageState createState() => _CurrentAffairsPageState();
}

class _CurrentAffairsPageState extends State<CurrentAffairsPage>
    with SingleTickerProviderStateMixin {
  late final String announcementsSheetId;
  late final Map<String, dynamic> credentials;
  late final GSheets gsheets;
  late Worksheet? gsheetCrudCurrentAffairs;
  List<Map<String, String>>? announcementsRows;
  final SwiperController _swiperController = SwiperController();

  // Animation properties
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Bookmarks
  Set<int> bookmarkedNews = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeGSheets();
    fetchCurrentAffairs();
  }

  void _initializeControllers() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  void _initializeGSheets() {
    try {
      announcementsSheetId = dotenv.env['ANNOUNCEMENTS_SHEET_ID'] ?? '';
      credentials = dotenv.env['GSHEETS_CREDENTIALS'] != null
          ? Map<String, dynamic>.from(
              json.decode(dotenv.env['GSHEETS_CREDENTIALS']!))
          : {};
      gsheets = GSheets(credentials);
    } catch (e) {
      debugPrint('Error initializing GSheets: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  Future<void> fetchCurrentAffairs() async {
    try {
      final controller = await gsheets.spreadsheet(announcementsSheetId);
      gsheetCrudCurrentAffairs = controller.worksheetByTitle('Sheet1');
      final fetchedRows = await gsheetCrudCurrentAffairs?.values.map.allRows();

      if (mounted) {
        setState(() {
          // Remove duplicate entries based on title
          if (fetchedRows != null) {
            final seenTitles = <String>{};
            announcementsRows = fetchedRows.where((row) {
              final title = row['Title'] ?? '';
              return seenTitles
                  .add(title); // Returns true if title wasn't seen before
            }).toList();
          }
        });
        _fadeController.forward();
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      if (mounted) {
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: _buildAppBar(),
      drawer: const Sidebar(userName: '', profileImagePath: ''),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchCurrentAffairs,
          color: Colors.green[700],
          backgroundColor: Colors.white,
          child: announcementsRows == null
              ? _buildShimmerEffect()
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildSwipeableCards(),
                ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 5,
      backgroundColor: Colors.green[50],
      title: Row(
        children: [
          Icon(Icons.newspaper, color: Colors.green[700]),
          const SizedBox(width: 8),
          Text(
            'Daily Current Affairs',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              color: Colors.green[900],
            ),
          ),
        ],
      ),
      actions: [
        if (announcementsRows != null && announcementsRows!.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/S.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
      ],
    );
  }

 Widget _buildSwipeableCards() {
  if (announcementsRows?.isEmpty ?? true) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No news is good news!\nPull to refresh.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          announcementsRows!.length > 1 
              ? 'Swipe up for more news!' 
              : 'Latest news update',
          style: GoogleFonts.poppins(
            color: Colors.green[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(
        child: Swiper(
          controller: _swiperController,
          itemCount: announcementsRows!.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildNewsCard(announcementsRows![index], index);
          },
          onIndexChanged: (index) {
            HapticFeedback.selectionClick();
          },
          loop: false, // Disable infinite looping
          layout: SwiperLayout.STACK,
          itemWidth: MediaQuery.of(context).size.width * 0.92,
          itemHeight: MediaQuery.of(context).size.height * 0.75,
          scrollDirection: Axis.vertical,
          viewportFraction: 0.8,
          scale: 0.9,
        ),
      ),
    ],
  );
}

  Widget _buildNewsCard(Map<String, String> row, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: AspectRatio(
                  aspectRatio: 12 / 9,
                  child: _buildImage(row['Image url']),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          row['Category'] ?? 'News',
                          style: GoogleFonts.poppins(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(row['Date'] ?? 'Today'),
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    row['Title'] ?? 'No Title',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        row['Description'] ?? 'No Description',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildImageLoadingIndicator();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/S.png',
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 8),
            Text(
              'Image on vacation!',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLoadingIndicator() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.green[300],
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(String date) {
  try {
    // Check if the date is in numeric format (e.g., "45573")
    if (RegExp(r'^\d+$').hasMatch(date)) {
      // Convert the numeric date to an integer
      final intDate = int.parse(date);

      // Google Sheets date starts from 1-1-1900, subtracting 2 accounts for leap year logic in Excel/Sheets.
      final origin = DateTime(1899, 12, 30);
      final parsedDate = origin.add(Duration(days: intDate));

      // Format the date to 'dd-MM-yyyy' or any desired format
      return '${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}';
    }

    // If date is already a string in the desired format, return as is
    return date;
  } catch (e) {
    debugPrint('Error formatting date: $e');
    return 'Invalid date';
  }
}
