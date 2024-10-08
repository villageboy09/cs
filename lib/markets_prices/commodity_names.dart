import 'package:cropsync/markets_prices/commodity_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommodityDetailsPage extends StatelessWidget {
  final String stateName; // Added state name
  final List<String> commodityNames; // List of commodity names for the state
  final List<Map<String, dynamic>> relatedRows;

  const CommodityDetailsPage({
    Key? key,
    required this.stateName,
    required this.commodityNames,
    required this.relatedRows,
  }) : super(key: key);


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
                child: const Image(
                 image:AssetImage("assets/log.png"),
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
