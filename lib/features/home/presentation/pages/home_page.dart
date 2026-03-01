import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/recent_trip_card.dart';
import '../widgets/dhay_story_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/special_offers_section.dart'; // Đã sửa: Thêm dấu ; và đúng thư mục widgets
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/../auth/presentation/bloc/profile_bloc.dart';
import '../../../auth/../auth/presentation/bloc/profile_state.dart';

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
              padding: const EdgeInsets.only(bottom: 120), // Tăng nhẹ để cuộn thoải mái hơn
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SỬA TẠI ĐÂY: Dùng BlocBuilder để lấy profile
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoadSuccess) {
                        return HomeHeader(profile: state.profile);
                      }
                      // Nếu đang load hoặc lỗi, vẫn hiện Header nhưng tên mặc định là "Khách"
                      return const HomeHeader(profile: null);
                    },
                  ),

                  // --- THANH TÌM KIẾM THEO CSS (Rectangle 397) - Chức năng CHUYỂN TRANG ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: GestureDetector(
                      onTap: () {
                        // ĐIỀU HƯỚNG SANG TRANG KHÁC TẠI ĐÂY
                        debugPrint("Chuyển sang trang tìm kiếm...");
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchSearchPage()));
                      },
                      child: Container(
                        height: 47, // Height: 47px từ CSS
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFD9D9D9),
                            width: 2.5, // Border: 2.5px
                          ),
                          borderRadius: BorderRadius.circular(15), // Border-radius: 15px
                        ),
                        child: Row(
                          children: [
                            // Icon từ Assets
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 10),
                              child: Image.asset(
                                'assets/icons/ic_search.png',
                                width: 20,
                                height: 20,
                                // color: const Color(0xFFB9B9B9), // Bỏ comment nếu muốn icon màu xám
                              ),
                            ),
                            // Dùng Text thay vì TextField để cố định giao diện
                            const Text(
                              "Bạn muốn đi đâu nào.....",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xFFB9B9B9), // Color: #B9B9B9
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  _sectionHeader("Đề xuất từ Dhay", 'assets/icons/ic_filter_menu.png'),
                  _horizontalList(const RecommendationCard(), 230),

                  // Đã đồng bộ: Sử dụng Widget tách riêng để dễ quản lý ảnh
                  const SpecialOffersSection(),

                  _sectionHeader("Chuyến đi gần đây", 'assets/icons/ic_filter_menu.png'),
                  _horizontalList(const RecentTripCard(), 215),

                  _sectionHeader("My Dhay Stories", 'assets/icons/ic_filter_menu.png'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Để lại dấu ấn và khoảnh khắc yêu thích, chia sẻ với DHAY",
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _horizontalList(const DhayStoryCard(), 320),

                  const SizedBox(height: 30), // Khoảng cách trước banner cuối

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

  Widget _sectionHeader(String title, String? iconPath) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12), // 24 là khoảng cách Top, 12 là Bottom
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