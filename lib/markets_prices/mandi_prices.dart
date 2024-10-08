// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:cropsync/markets_prices/commodity_names.dart';
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
  bool _isLoading = true;  // Tracks loading state
  bool _isDataFetched = false; // Tracks if data has been fetched

  List<String> filteredStates = [];
  List<String> _uniqueStates = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeGSheets();
    searchController.addListener(_filterStates);
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
      fetchMandiPrices(); // Fetch data directly
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
  if (_isDataFetched || !mounted) return; // Prevents unnecessary calls

  try {
    if (mounted) {
      setState(() {
        _isLoading = true; // Indicate loading
      });
    }
    final spreadsheet = await gsheets.spreadsheet(announcementsSheetId);
    final worksheet = spreadsheet.worksheetByTitle('announcements');
    announcementsRows = await worksheet?.values.map.allRows();
    _isDataFetched = true; // Data fetched successfully

    if (mounted) {
      setState(() {
        _uniqueStates = getUniqueStates(); // Populate unique states
      });
    }
  } catch (e) {
    // Handle errors gracefully
    if (mounted) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data: $e')));
    }
  } finally {
    if (mounted) {
      // Update loading state once done
      setState(() {
        _isLoading = false; // End loading
      });
    }
  }
}


  List<String> getUniqueStates() {
    final Set<String> uniqueStates = {};
    for (var row in announcementsRows ?? []) {
      if (row['State'] != null) {
        uniqueStates.add(row['State']);
      }
    }
    return uniqueStates.toList()..sort();
  }

  void _filterStates() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredStates = _uniqueStates.where((state) =>
          state.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        elevation: 0,
        title: Text('Mandi Prices',
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
      drawer: const Sidebar(userName: '', profileImagePath: '',),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchMandiPrices, // Pull to refresh data
                child: _isLoading 
                    ? _buildShimmerEffect() // Show loading effect
                    : _buildStateGrid(), // Show the grid with states
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
          hintText: 'Search states...',
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

  Widget _buildStateGrid() {
    final statesToShow = searchController.text.isEmpty
        ? getUniqueStates()
        : filteredStates;

    return statesToShow.isEmpty
        ? Center(child: Text('No states found', style: GoogleFonts.poppins()))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: statesToShow.length,
            itemBuilder: (context, index) {
              final stateName = statesToShow[index];
              return _buildStateCard(stateName);
            },
          );
  }

  Widget _buildStateCard(String stateName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommodityDetailsPage(
              stateName: stateName,
              relatedRows: announcementsRows!
                  .where((row) => row['State'] == stateName)
                  .toList(),
              commodityNames: getCommoditiesForState(stateName), // Get the list of commodities for the state
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
              colors: [Colors.white, Colors.lightBlue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  stateName,
                  style: GoogleFonts.poppins(
                    color: Colors.teal.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> getCommoditiesForState(String stateName) {
    final Set<String> commodities = {};
    for (var row in announcementsRows ?? []) {
      if (row['State'] == stateName && row['Commodity'] != null) {
        commodities.add(row['Commodity']);
      }
    }
    return commodities.toList()..sort(); // Return sorted list of commodities for the state
  }
}
