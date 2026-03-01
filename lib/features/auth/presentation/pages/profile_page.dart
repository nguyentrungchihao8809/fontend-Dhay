import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../bloc/profile_event.dart';
import '../widgets/profile_info_tile.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/domain/entities/profile_entity.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Gọi sự kiện load dữ liệu khi vào màn hình
    context.read<ProfileBloc>().add(GetProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      // SỬA TẠI ĐÂY: Bao bọc BlocBuilder bằng BlocListener
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Khi state chuyển về ProfileInitial (đã xóa token thành công trong Bloc)
          if (state is ProfileInitial) {
            // Thực hiện thoát trang và đẩy về màn hình login
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login', // Đảm bảo tên này khớp với tên trong main.dart
                  (route) => false, // Xóa sạch lịch sử để không quay lại được trang profile
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.black));
            }

            if (state is ProfileLoadSuccess) {
              final profile = state.profile;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    _buildProfileHeader(profile),
                    const SizedBox(height: 30),

                    ProfileInfoTile(label: "Tên", value: profile.fullName),
                    ProfileInfoTile(label: "Số điện thoại", value: profile.phoneNumber),
                    ProfileInfoTile(label: "Giới tính", value: profile.gender, showArrow: true),
                    ProfileInfoTile(label: "Loại xe", value: profile.vehicleType, showArrow: true),
                    ProfileInfoTile(label: "Hãng xe", value: profile.vehicleBrand, showArrow: true),
                    ProfileInfoTile(label: "Biển số xe", value: profile.plateNumber),
                    ProfileInfoTile(label: "Email", value: profile.email),
                    ProfileInfoTile(label: "Ngôn ngữ", value: profile.language, showArrow: true),

                    const SizedBox(height: 30),
                    _buildGreetingCard(),
                    const SizedBox(height: 35),
                    _buildLogoutButton(context),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            }

            if (state is ProfileLoadFailure) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Header với bóng đổ và bo góc theo CSS: Rectangle 325
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Tài khoản DHAY",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }

  // Avatar (115x115) & Star Badge (Star 30)
  Widget _buildProfileHeader(ProfileEntity profile) {
    return Column(
      children: [
        const Text(
          "Thông tin tài khoản",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 25),
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar chính: image 435
            Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 2),
                image: DecorationImage(
                  image: NetworkImage(profile.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Badge Sao: Star 30
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.starRating,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 24),
              ),
            ),
            // Text Rating: 3.1
            Positioned(
              right: -45,
              top: 12,
              child: Text(
                profile.rating.toString(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Greeting Card: Rectangle 111 & Roboto text
  Widget _buildGreetingCard() {
    return Container(
      width: 358,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
        // Nếu có image.png làm background, dùng DecorationImage ở đây
      ),
      child: Column(
        children: const [
          Text(
            "Cảm ơn bạn đã tin tưởng và đồng hành cùng DHAY.",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "DHAY rất vui khi được cùng bạn chia sẻ những khoảnh khắc đáng nhớ.",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Nút đăng xuất: Frame 27
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: 196,
      height: 43,
      child: ElevatedButton(
        onPressed: () {
          // --- THAY ĐỔI TẠI ĐÂY ---
          // Gửi lệnh đăng xuất vào Bloc để xóa SharedPreferences
          context.read<ProfileBloc>().add(LogoutRequested());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.logoutBtnBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Đăng xuất",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}