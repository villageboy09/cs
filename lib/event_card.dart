import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventDescription;
  final String eventDateTime;

  const EventCard({
    super.key,
    required this.eventName,
    required this.eventDescription,
    required this.eventDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // This makes the card edges rounded
        ),
        elevation: 5, // This elevates the card
        margin: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            
            borderRadius: BorderRadius.circular(15), // This makes the container edges rounded
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color:Colors.white
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        eventDescription,
                        style: GoogleFonts.monda(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      eventDateTime,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
