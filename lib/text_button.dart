import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final Widget page;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const TextButtonWidget({
    super.key,
    required this.text,
    required this.page,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 30 is the radius value
        ),
        padding: const EdgeInsets.all(16), // Add your desired padding
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
