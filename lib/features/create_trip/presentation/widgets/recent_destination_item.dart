import 'package:flutter/material.dart';

class RecentDestinationItem extends StatelessWidget {
  final String startLocation;
  final String endLocation;
  final String distance;
  final String duration;

  const RecentDestinationItem({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD9D9D9),
            blurRadius: 10,
            spreadRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Icon Line
              Column(
                children: [
                  const Icon(Icons.radio_button_checked, size: 14, color: Colors.black),
                  Container(width: 2, height: 26, color: const Color(0xFFB9B9B9)),
                  const Icon(Icons.location_on, size: 14, color: Colors.black),
                ],
              ),
              const SizedBox(width: 12),
              // Address Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      startLocation,
                      style: _textStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      endLocation,
                      style: _textStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Distance & Duration (Bottom Right)
          Positioned(
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(distance, style: _infoStyle()),
                Text(duration, style: _infoStyle()),
              ],
            ),
          ),
          // Bookmark Icon (Top Right)
          const Positioned(
            right: 0,
            top: 0,
            child: Icon(Icons.bookmark_border, size: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() => const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: Colors.black,
  );

  TextStyle _infoStyle() => const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 8,
    color: Color(0xFF959595),
  );
}