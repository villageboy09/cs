import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecificCommodityDetailPage extends StatelessWidget {
  final String commodityName;
  final String stateName;
  final List<Map<String, dynamic>> relatedRows;

  const SpecificCommodityDetailPage({
    Key? key,
    required this.commodityName,
    required this.stateName,
    required this.relatedRows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          commodityName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: relatedRows.isEmpty 
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
                child: Text(
                  'No details available for this commodity.',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.04), // Responsive font size
                ),
              ),
            )
          : ListView.builder(
              itemCount: relatedRows.length,
              itemBuilder: (context, index) {
                final row = relatedRows[index];
                return _buildDetailCard(row, screenWidth);
              },
            ),
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> row, double screenWidth) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.03, horizontal: screenWidth * 0.04), // Responsive margin
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Market',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045, // Responsive font size
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${row['Market'] ?? 'N/A'}',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04), // Responsive font size
            ),
            const SizedBox(height: 12),
            Divider(thickness: 1, color: Colors.grey[300]), // Divider for separation
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'District',
                        style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold), // Responsive font size
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${row['District'] ?? 'N/A'}',
                        style: GoogleFonts.poppins(fontSize: screenWidth * 0.04), // Responsive font size
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arrival Date',
                        style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold), // Responsive font size
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${row['Arrival Date'] ?? 'N/A'}',
                        style: GoogleFonts.poppins(fontSize: screenWidth * 0.04), // Responsive font size
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(thickness: 1, color: Colors.grey[300]), // Divider for separation
            const SizedBox(height: 12),
            Text(
              'Variety',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold), // Responsive font size
            ),
            const SizedBox(height: 4),
            Text(
              '${row['Variety'] ?? 'N/A'}',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04), // Responsive font size
            ),
            const SizedBox(height: 12),
            Divider(thickness: 1, color: Colors.grey[300]), // Divider for separation
            const SizedBox(height: 12),
            Text(
              'Modal Price',
              style:
                  GoogleFonts.poppins(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold), // Responsive font size
            ),
            const SizedBox(height: 4),
            Text(
              '₹${row['Modal Price'] ?? 'N/A'}',
              style:
                  GoogleFonts.poppins(fontSize: screenWidth * 0.04, fontWeight:
                  FontWeight.bold, color:
                  Colors.teal), // Responsive font size and color
            ),
          ],
        ),
      ),
    );
  }
}