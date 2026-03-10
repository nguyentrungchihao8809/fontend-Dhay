import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/home_header.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/recent_trip_card.dart';
import '../widgets/dhay_story_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/special_offers_section.dart';

// Import các Bloc cần thiết
import '../../../auth/presentation/bloc/profile_bloc.dart';
import '../../../auth/presentation/bloc/profile_state.dart';
import '../../../register_driver/presentation/pages/register_driver_page.dart';
import '../../../home_driver/presentation/pages/home_driver_page.dart';
import '../../../register_driver/presentation/bloc/register_driver_bloc.dart';
import '../../../register_driver/presentation/bloc/register_driver_event.dart';
import '../../../register_driver/presentation/bloc/register_driver_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterDriverBloc, RegisterDriverState>(
      listener: (context, state) {
        // Xử lý điều hướng khi có kết quả trả về từ API check status
        if (state is DriverStatusResult) {
          if (state.isRegistered) {
            // Đã là tài xế -> Chuyển đến trang quản lý tài xế
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeDriverPage()),
            );
          } else {
            // Chưa đăng ký -> Chuyển đến trang đăng ký
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DriverRegisterPage()),
            );
          }
        } else if (state is RegisterDriverFailure) {
          // Hiển thị thông báo nếu check status lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- PHẦN HEADER & CHECK STATUS ---
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, profileState) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // Gửi sự kiện yêu cầu kiểm tra trạng thái đăng ký lên Server
                            context.read<RegisterDriverBloc>().add(OnCheckDriverStatus());
                          },
                          child: BlocBuilder<RegisterDriverBloc, RegisterDriverState>(
                            builder: (context, driverState) {
                              // Nếu đang loading thì có thể thêm hiệu ứng mờ hoặc Spinner nhỏ ở đây
                              return Opacity(
                                opacity: driverState is RegisterDriverLoading ? 0.6 : 1.0,
                                child: profileState is ProfileLoadSuccess
                                    ? HomeHeader(profile: profileState.profile)
                                    : const HomeHeader(profile: null),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    // --- THANH SEARCH ---
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
                              padding: const EdgeInsets.only(left: 15, right: 10), // Dùng Padding chuẩn
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10),
                                child: Image.asset('assets/icons/ic_search.png', width: 20, height: 20),
                              ),
                            ),
                            const Text(
                              "Bạn muốn đi đâu nào.....",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Color(0xFFB9B9B9),
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    _sectionHeader("Đề xuất từ Dhay", 'assets/icons/ic_filter_menu.png'),
                    _horizontalList(const RecommendationCard(), 230),

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
      ),
    );
  }

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