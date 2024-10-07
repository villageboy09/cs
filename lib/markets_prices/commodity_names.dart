import 'package:cropsync/markets_prices/commodity_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommodityDetailsPage extends StatelessWidget {
  final String stateName; // Added state name
  final List<String> commodityNames; // List of commodity names for the state
  final List<Map<String, dynamic>> relatedRows;

  CommodityDetailsPage({
    Key? key,
    required this.stateName,
    required this.commodityNames,
    required this.relatedRows,
  }) : super(key: key);

  // Placeholder image URLs for commodities
  final Map<String, String> commodityImages = {
    'Paddy(Dhan)(Common)': 'https://example.com/images/paddy.png',
    'Banana': 'https://picsum.photos/200/300',
    'Capsicum': 'https://example.com/images/capsicum.png',
    'Lemon': 'https://example.com/images/lemon.png',
    // Add more commodities and their image URLs here
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          stateName, // Display only the state name
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: commodityNames.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final commodityName = commodityNames[index];
          return _buildCommodityCard(context, commodityName);
        },
      ),
    );
  }

  Widget _buildCommodityCard(BuildContext context, String commodityName) {
    final imageUrl = commodityImages[commodityName] ??
        'https://example.com/images/placeholder.png';

    return GestureDetector(
      onTap: () {
        // Navigate to the detailed information page of the commodity
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecificCommodityDetailPage(
              commodityName: commodityName,
              stateName: stateName,
              relatedRows: relatedRows
                  .where((row) =>
                      row['Commodity'] ==
                      commodityName) // Filtering based on 'Commodity'
                  .toList(),
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(Icons.error)); // Placeholder for error
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                commodityName,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
