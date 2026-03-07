import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 146, // Rectangle 392
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x26D9D9D9), blurRadius: 4, spreadRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset('assets/images/img_recommend_location.png', height: 93, width: 146, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nhà Thờ Đức Bà", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(width: 2, height: 15, color: AppColors.textGrey), // Line 72
                    const SizedBox(width: 5),
                    const Text("Bưu điện thành phố", style: TextStyle(fontSize: 12, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 10),
                // Rectangle 250: Đặt Chuyến Button
                Container(
                  width: 125,
                  height: 25,
                  decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                    child: Text("Đặt Chuyến", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}