import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RecentTripCard extends StatelessWidget {
  const RecentTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 4, spreadRadius: 4)],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/images/maps/img_map_preview.png', height: 72, width: 247, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(radius: 6.5, backgroundColor: Colors.black),
              const SizedBox(width: 8),
              const Text("HỘI AN", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          // Thêm các Line và Text phụ theo CSS của bạn tại đây...
        ],
      ),
    );
  }
}