// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shimmer/shimmer.dart';

class MandiPrices extends StatefulWidget {
  const MandiPrices({Key? key}) : super(key: key);

  @override
  _MandiPricesState createState() => _MandiPricesState();
}

class _MandiPricesState extends State<MandiPrices> {
  final announcementsSheetId = "1rMMbedzEVB9s72rUmwUAEdqlHt5Ri4VCRxmeOe651Yg";
  final credentials = {
    "type": "service_account",
    "project_id": "news-432020",
    "private_key_id": "8cea6aa039d1e9c6f1d2b2179e66517798544306",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDI0e2m9k5JSBEk\nDJ9YjyFAWNOiNTE4KEN5L9kiXFtrF665BvoFEgzWLhrlm3XEGJFTtDiwI+kDZy4D\nJk/uf6oYl6xIDCqhhL6FElELYXg8I/dPH6+BAgoYercZ7GHlqO9IQ9UpO5GefanY\nlYza5Cr8+qHzdmawHwxpejcMeHha8QiD6A9OEttBnA0Y2A7dXOc36IsHROdiI/0q\nKpdkY2OS5svHYmaC0YW7e/d88eYKqt7DZVbHWTdf7+YvCglt4MoyiMIdJCTkAqum\nDnBjYpp2RW7V158W6s9gdoOVvzSNqTdlwOcwpKfWn3uoJymcOUCQm/iXKPScJvl5\ncohjLbk3AgMBAAECggEAMVEwskyRvDhpETfSWB7KVTGbQ54ZiMeGjnfcNK6Gut2V\niJX4h48/vMeUzmdnu/Emm25Kb6NaAX5w09AwWAtdG+3/nq/yNjlRyn9NjORycR6K\nCRHoeV+lWA6m8cRV5F8g6FfUPOyGnewRboGHlmfrULZCWHZu0HjHhQ3BAByDvh08\npG+13bsWFdojCNRX6Wb9T62LII2wo6+49J6GfrRj7DaxY9Qa4pYOTyh7ZouaZOH/\nnSRVSW/Co5Nr4bXG0S0d6wASd8U1ljYAOw5traAu7cTdW4O4EW5dxcdEW2amtDx4\n1j6lCYqqyTN4/l3aTLXk+UF2C32iu4NQrs5+26KeaQKBgQD3m0nVDQ+Ok0IBaZZR\nATGS9IgQGeqfd5I/ZixG3ssXdlAnKBfyLLeCiRRUABVAeDzuoYuduHTtsw0GfDar\nAOjbg4n8eUA4rkwdbnD13lPPCNLQ9oejH6lEy+5H9MzLl1+5wB1dl+tf4pCaTa5U\n9q5SUyr6FwxkW3easNUjWiatuQKBgQDPoKEuZ6ZCjs52v7CQMJmkZzcs3dzyM1Vw\nbMfj4T1OALom1C++qYuz4spXvBaiHNZy5Mevwb0aHmw1Fo3Z234lahkpIpRIiav8\npOUp1+gcORy0wU3wYkPaODJm1bcSH+8s0SRlWgbbjkFY26/xRsuR5R/B09qlLsQf\n4Zeqdo6WbwKBgBpqpuXkDtTXQSOFcFQUHIXhMOMG4NFCoIfDDtZAzsoiBUsoK+Xa\nf3mdxl1v5NSL/3Q2J/8bvt3dTHZ0qiB0aGODFSWqif+CGPzK26JfpfFgr507sBzn\nM9fzKejjZTYTYFMg/AEQRDxmn6bWwtKtvstptBwaeWf7mjcWxqaO57GBAoGBAJnj\nFlPMot/l9ITzIqxcOSQvFCf+8Mna3lKLbcQqp0NvKomo7xJDm7XiO9K3J5dUBGX3\nx0EvOTdooQ7f/pcgJekZMDja1kjFMWH53Zgb3H8+nVYjh97JFj1hNYoekKewX5c6\nE93C0h5c23Y+rbMIo80oo1cH7KBNfzOaAs1nPdulAoGAR38l6Qe02sQOBen0c/gV\n1cI5+eafU5K2NefZK3DAqoXf8eccOc/dSOPU3vWHjKXTFw7QEP6cU3unEvstCxRY\nNSmsOfF3XfiQHxVXAJG3QpkXuEBSzbOqVPl78b1diZ9bjtDR8REpagVbjz0w6xfg\nna26q6NFeaswPfBVLoEONMQ=\n-----END PRIVATE KEY-----\n",
    "client_email": "news-512@news-432020.iam.gserviceaccount.com",
    "client_id": "101236323039893966383",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/news-512%40news-432020.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

    late final GSheets gsheets;
  List<Map<String, dynamic>>? announcementsRows;
  Future<void>? _fetchDataFuture;
  bool _isDataFetched = false; // Track if data has been fetched

  @override
  void initState() {
    super.initState();
    gsheets = GSheets(credentials);
    _fetchDataFuture = fetchMandiPrices();
  }

  Future<void> fetchMandiPrices() async {
  if (_isDataFetched || !mounted) return; // Prevent re-fetching and check if mounted

  try {
    final spreadsheet = await gsheets.spreadsheet(announcementsSheetId);
    final worksheet = spreadsheet.worksheetByTitle('announcements');
    announcementsRows = await worksheet?.values.map.allRows();
    _isDataFetched = true; // Mark data as fetched
    
    if (mounted) { // Check if the widget is still mounted before calling setState
      setState(() {});
    }
  } catch (e) {
    if (mounted) { // Check if the widget is still mounted before printing the error
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
    return uniqueCommodities.toList()..sort(); // Sort alphabetically
  }



 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'Daily Mandi Prices',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: const Sidebar(profileImageUrl: '', userName: ''),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Trigger data fetch on refresh
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
        itemCount: 8, // Show 8 shimmer items
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
    final uniqueCommodities = getUniqueCommodities();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: uniqueCommodities.length,
      itemBuilder: (context, index) {
        final commodityName = uniqueCommodities[index];
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
              relatedRows: announcementsRows!.where((row) => row['Commodity'] == commodityName).toList(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal.shade100,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  commodityName,
                  style: GoogleFonts.poppins(
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
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
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
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
        margin: const EdgeInsets.symmetric(vertical: 12),
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
              _buildDetailRow(context, 'Modal Price:', '₹ ${row['Modal Price'] ?? 'N/A'}', fontSize: fontSize, isPrice: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isPrice = false, required double fontSize}) {
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