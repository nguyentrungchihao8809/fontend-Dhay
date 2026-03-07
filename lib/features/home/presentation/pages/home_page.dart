import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/recent_trip_card.dart';
import '../widgets/dhay_story_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/special_offers_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/profile_bloc.dart';
import '../../../auth/presentation/bloc/profile_state.dart';
// Nhớ import file này để nó biết đường mà bay sang nha cưng
import '../../../auth/presentation/pages/driver_register_page.dart';

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
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ĐÂY RỒI! VÙNG BẤM CHUẨN XÁC DÀNH CHO CƯNG IU ---
                  // Anh bọc GestureDetector sát sàn sạt cái HomeHeader thôi nhé
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque, // Thêm cái này để bấm vào khoảng trắng trong box vẫn ăn nha
                        onTap: () {
                          // Chỉ bấm vào vùng "Hi, BauBau" và Mũi tên mới nhảy trang nè
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DriverRegisterPage()),
                          );
                        },
                        child: state is ProfileLoadSuccess
                            ? HomeHeader(profile: state.profile)
                            : const HomeHeader(profile: null),
                      );
                    },
                  ),

                  // Thanh tìm kiếm - Vùng này bấm vào không bị nhảy sang Driver nè
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Container(
                      height: 47,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFD9D9D9), width: 2.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Image.asset('assets/icons/ic_search.png', width: 20, height: 20),
                          ),
                          const Text(
                            "Bạn muốn đi đâu nào.....",
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFFB9B9B9), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),

                  _sectionHeader("Đề xuất từ Dhay", 'assets/icons/ic_filter_menu.png'),
                  _horizontalList(const RecommendationCard(), 230),

                  // CÁI NÀY LÀ CÁI MÀU NÂU NÈ - Anh để nó nằm riêng, không bọc GestureDetector
                  // Nên giờ cưng bấm vào đây nó sẽ im re, không nhảy sang trang Driver nữa đâu!
                  const SpecialOffersSection(),

                  _sectionHeader("Chuyến đi gần đây", 'assets/icons/ic_filter_menu.png'),
                  _horizontalList(const RecentTripCard(), 215),

                  _sectionHeader("My Dhay Stories", 'assets/icons/ic_filter_menu.png'),
                  _horizontalList(const DhayStoryCard(), 320),

                  const SizedBox(height: 30),
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

  // Mấy cái này anh giữ nguyên cho cưng nè
  Widget _sectionHeader(String title, String? iconPath) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          if (iconPath != null) Image.asset(iconPath, width: 22, height: 22),
        ],
      ),
    );
  }

  Widget _horizontalList(Widget child, double height) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 8),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) => child,
      ),
    );
  }
}