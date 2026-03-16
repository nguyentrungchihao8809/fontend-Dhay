import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/location_entity.dart';

class HistoryListItem extends StatelessWidget {
  final LocationEntity location;
  final VoidCallback onTap;

  const HistoryListItem({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 31, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F2F2),
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 4),
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.name,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              '${location.distance} km – ${location.address}',
              style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF555555)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}