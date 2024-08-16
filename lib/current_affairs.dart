// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shimmer/shimmer.dart';

class CurrentAffairsPage extends StatefulWidget {
  const CurrentAffairsPage({Key? key}) : super(key: key);

  @override
  _CurrentAffairsPageState createState() => _CurrentAffairsPageState();
}

class _CurrentAffairsPageState extends State<CurrentAffairsPage> {
  final announcementsSheetId = "1-KDHaQH4F7cvFXe9DvmGT7RGcJefP5XaFGgv76LujUI";
  final credentials = {
  "type": "service_account",
  "project_id": "current-affairs-432515",
  "private_key_id": "9d566f81c5ae104f1ca0cb5965824d2c48644dfd",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCu+FkAxAnqPe43\n3SR7AMsplSr6AqitLUhUuT5lhfan2G7Wzem2waqy/B5eepHg9xJv/32fRnZGPyZ8\nFczauRrpB9StwTBeYugwpaZR+yGd8zVlqPFw1ujuhOokoMzL0tqvbRDD+hrglvuM\nqHP0ADAz5odA8/iWpsB9w/d9Tc261zjEFKboXvXYznZOi2/eLxRC00+GLtb87IrZ\nm03jArkimZQDGy+pMrgY7xTUZS7E+QjlxG/ge7mQmL2lWXRi2POfWkHw+QL9po/z\n2Iaj/qxjoxzdWhonyZgcxuLug2IitEPiYScQOLrAVKNLDAKBp+UO6RZokbEsvE1M\n9BMSPAOXAgMBAAECggEAKMmpCdYpT4s3VJt/LRNeyOdGmPh0tMYZFfMG+iiz+qWo\nFPf0cw+LiOTf+XtONWizSht/f9kvqil/ga6dTiGXhdo2+HhQG7in0utSrcrCp+zx\ntiyfeAQJUcz3PimkBCG3q+xbW6waht97bWs5eJhwpDCpt/kHqqrdtZOwxmuUOWke\nWfalWjzS0vz1vaQzOeBOh2l4TXgEQK4f6fQKxwCDx9B11zb+uaB80BZC9+8fYoia\nvIsrZH/JMmA5S+DgROToyvko122QCn/2eeEq5HznkmJvnkx+TbyN4FDpLJ1Kfc4J\nOsKOoWY9vXT8GEcqNiBamdnvqFuUtd3TKDm7mOMIKQKBgQDqRXUvFT0RGjGC0bG6\nQz/K8QCmNaaUmvza1mlpGs5oyDBlREMvdIQitwY4bvEkZpCFzT2ql2qEsu9n7IUH\n0ro9AQaIgvNkjSNAeYnP/g28uYAXHWgWgcVi0DETMlZ7f0qlo4fVBZKs9IUVJFMD\nx65r0lcuL1I2GNExP4CbMyOqHwKBgQC/MtdHe9PDuGiKcmMKd9Q1j1HkI8/Oe1VD\n0DjLJuh8N3PSC27P08ZLk5M7wVZCMOW2oOKqUA9kvKkY7VV7QQis2e5qp7vH+m26\ncC8dPQGEEtUUKjslorN0t4nHxE+z5+nSpaNMfvEr9G78WNqvOlrIvDRyWArwaKxL\n+/EyTdzniQKBgDnjQ9uIgfhx4n4S1rnR2DeLab+oTis2SPjCNnXUO+DEZsD/JyLY\nxbXWR+E1+Lwn49pMJsq6c4WquWGSniSau45LbJPa182m2mkaHyWX/0j9BVuw1oGJ\nO375NscpjxkhEQ7w46WNpPq7yQ66VREADGd0KDqvUr8vTrG+oUa4Uj29AoGAJWsz\nyp+nUBSVERNV4sSU2W6VHksL7mMgysbDdq7ErRrFJgRqyW2uzzewhu9NjGK5ckaG\nVcKZYKOzjFdWdWrC4eE80c7F51tRgj1WWyiHVWvCG9IwBSuUZ3FMG7aFyrXGgx07\nmkr1tB6AYg6ZrdWD0ulSclZcvbQelDhYefnXE9ECgYEAks8OoBVi6GC3m0sefYEg\nDmAMzf3MI3ewx8lnSra4CIWH3y7lNIZbwIncCQ5MyoI9jPT5lyE1OWVgw4du9Hfr\n+pOOWMZ79ehATY+7umPfchIYZ4YcJNYdX5vfhV6pPoOnKvP8t6sHkWSvuX5E9P4k\nUZ8gpctLsUu/k+IUKCmNkKw=\n-----END PRIVATE KEY-----\n",
  "client_email": "current-affairs@current-affairs-432515.iam.gserviceaccount.com",
  "client_id": "103699081930348855332",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/current-affairs%40current-affairs-432515.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};
late final GSheets gsheets;
  late Worksheet? gsheetCrudCurrentAffairs;
  List<Map<String, String>>? announcementsRows;

  @override
  void initState() {
    super.initState();
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
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'Current Affairs',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
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
                        child: Text(
                          'No Image',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
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