import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DhayStoryCard extends StatelessWidget {
  const DhayStoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage('assets/images/img_story_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 12, left: 12, right: 12,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.storyYellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("DHAY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                  const Text("Góc nhỏ Hội An", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Text("Với món cao lầu đậm đà, bạn đã thử chưa?", style: TextStyle(fontSize: 10)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("HỘI AN ", style: TextStyle(color: Colors.white, fontSize: 10)),
                        Image.asset('assets/icons/ic_star_fill.png', width: 12, height: 12, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}