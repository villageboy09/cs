import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CropCard extends StatefulWidget {
  final String imageUrl; // Changed from image to imageUrl
  final String label;
  final VoidCallback? onTap;

  const CropCard({
    super.key,
    required this.imageUrl, // Changed from image to imageUrl
    required this.label,
    this.onTap,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CropCardState createState() => _CropCardState();
}

class _CropCardState extends State<CropCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _pressed
            ? Matrix4.translationValues(0.0, -5.0, 0.0)
            : Matrix4.translationValues(0.0, 0.0, 0.0),
        child: Card(
          elevation: 2,
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                widget.imageUrl, // Use imageUrl here
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CropDetailPage extends StatelessWidget {
  final String label;
  final List<String> imageUrls;

  const CropDetailPage({
    super.key,
    required this.label,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: const Text('More Information'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('This is a description of $label.'),
                      const SizedBox(height: 10),
                      const Text(
                        'Images:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Use ListView.builder to display multiple images
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          String imageUrl = imageUrls[index];
                          return Image.network(
                            imageUrl,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ],
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
