// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';

import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shimmer/shimmer.dart';

class MandiPrices extends StatefulWidget {
  const MandiPrices({Key? key}) : super(key: key);

  @override
  _MandiPricesState createState() => _MandiPricesState();
}

class _MandiPricesState extends State<MandiPrices> {
   late final String announcementsSheetId;
  late final String credentials;
  
  late final GSheets gsheets;
  List<Map<String, dynamic>>? announcementsRows;
  Future<void>? _fetchDataFuture;
  bool _isDataFetched = false;

  List<String> filteredCommodities = [];
  List<String> _uniqueCommodities = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeGSheets();
    searchController.addListener(_filterCommodities);
  }

  void _initializeGSheets() {
  final mandiId = dotenv.env['MANDI_ID'];
  final mandiCredentials = dotenv.env['MANDI_CREDENTIALS'];
  
  if (mandiId == null || mandiCredentials == null) {
    print('Error: Environment variables not set correctly');
    return;
  }
  
  announcementsSheetId = mandiId;
  
  try {
    // Remove any leading/trailing whitespace and parse the JSON
    final credentialsJson = json.decode(mandiCredentials.trim());
    
    // Convert back to a properly formatted JSON string
    credentials = json.encode(credentialsJson);
    
    gsheets = GSheets(credentials);
    _fetchDataFuture = fetchMandiPrices();
  } catch (e) {
    print('Error initializing GSheets: $e');
  }
}
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchMandiPrices() async {
    if (_isDataFetched || !mounted) {
      return;
    }

    try {
      final spreadsheet = await gsheets.spreadsheet(announcementsSheetId);
      final worksheet = spreadsheet.worksheetByTitle('announcements');
      announcementsRows = await worksheet?.values.map.allRows();
      _isDataFetched = true;

      if (mounted) {
        setState(() {
          _uniqueCommodities = getUniqueCommodities();
        });
      }
    } catch (e) {
      if (mounted) {
        print('Error fetching data: $e');
      }
    }
  }

  List<String> getUniqueCommodities() {
    final Set<String> uniqueCommodities = {};
    for (var row in announcementsRows ?? []) {
      if (row['Commodity'] != null) {
        uniqueCommodities.add(row['Commodity']);
      }
    }
    return uniqueCommodities.toList()..sort();
  }

  void _filterCommodities() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCommodities = _uniqueCommodities.where((commodity) =>
          commodity.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
      backgroundColor: Colors.green[50],
        elevation: 0,
        title: Text('Daily Mandi Prices',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/S.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      drawer: const Sidebar( userName: '', profileImagePath: '',),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await fetchMandiPrices();
                },
                child: FutureBuilder<void>(
                  future: _fetchDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerEffect();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return _buildCommodityGrid();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      
      padding: const EdgeInsets.all(16),
      color: Colors.green[50],
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search commodities...',
          prefixIcon: const Icon(Icons.search, color: Colors.green),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 8,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildCommodityGrid() {
    final commoditiesToShow = searchController.text.isEmpty
        ? getUniqueCommodities()
        : filteredCommodities;

    return commoditiesToShow.isEmpty
        ? Center(child: Text('No commodities found', style: GoogleFonts.poppins()))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: commoditiesToShow.length,
            itemBuilder: (context, index) {
              final commodityName = commoditiesToShow[index];
              return _buildCommodityCard(commodityName);
            },
          );
  }

  Widget _buildCommodityCard(String commodityName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommodityDetailsPage(
              commodityName: commodityName,
              relatedRows: announcementsRows!
                  .where((row) => row['Commodity'] == commodityName)
                  .toList(),
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade200, Colors.teal.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              commodityName,
              style: GoogleFonts.poppins(
                color: Colors.teal.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class CommodityDetailsPage extends StatelessWidget {
  final String commodityName;
  final List<Map<String, dynamic>> relatedRows;

  const CommodityDetailsPage({
    Key? key,
    required this.commodityName,
    required this.relatedRows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          commodityName,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: relatedRows.length,
        itemBuilder: (context, index) {
          final row = relatedRows[index];
          return _buildCommodityCard(context, row);
        },
      ),
    );
  }

Widget _buildCommodityCard(BuildContext context, Map<String, dynamic> row) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final fontSize = isSmallScreen ? 14.0 : 16.0;
    final cardWidth = screenSize.width * 0.9;

    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade50, Colors.white],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context, 'State:', row['State'] ?? 'N/A', fontSize: fontSize),
              _buildDetailRow(context, 'District:', row['District'] ?? 'N/A', fontSize: fontSize),
              _buildDetailRow(context, 'Market:', row['Market'] ?? 'N/A', fontSize: fontSize),
              _buildDetailRow(context, 'Variety:', row['Variety'] ?? 'N/A', fontSize: fontSize),
              _buildDetailRow(context, 'Modal Price:', '₹ ${row['Modal Price'] ?? 'N/A'}',
                  fontSize: fontSize, isPrice: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {bool isPrice = false, required double fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                color: Colors.teal.shade800,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
                fontSize: fontSize,
                color: isPrice ? Colors.green.shade700 : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}