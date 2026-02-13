import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/recent_trip_card.dart';
import '../widgets/dhay_story_card.dart';
import '../widgets/custom_bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),

                  _sectionHeader("Đề xuất từ Dhay", 'assets/icons/ic_filter_menu.png'),
                  _horizontalList(const RecommendationCard(), 200),

                  _sectionHeader("Chuyến đi gần đây", 'assets/icons/ic_filter_menu.png'),
                  _horizontalList(const RecentTripCard(), 180),

                  const SizedBox(height: 20),
                  // Banner môi trường ở cuối screenshot
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset('assets/images/img_env_banner.png', fit: BoxFit.fitWidth),
                    ),
                  ),

                  _sectionHeader("My Dhay Stories", 'assets/icons/ic_filter_menu.png'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Để lại dấu ấn và khoảnh khắc yêu thích, chia sẻ với DHAY",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  const SizedBox(height: 10),
                  _horizontalList(const DhayStoryCard(), 320),
                ],
              ),
            ),
            const Positioned(
              bottom: 0, left: 0, right: 0,
              child: CustomBottomNav(),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Image.asset(iconPath, width: 20, height: 20),
        ],
      ),
    );
  }

  Widget _horizontalList(Widget child, double height) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) => child,
      ),
    );
  }
}