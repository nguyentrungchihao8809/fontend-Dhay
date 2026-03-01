import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  // THÊM: Biến profile để nhận dữ liệu từ HomePage
  final dynamic profile;

  // CẬP NHẬT: Constructor nhận tham số (không để const ở đây nữa)
  const HomeHeader({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // --- BANNER NỀN (Giữ nguyên) ---
            Container(
              width: double.infinity,
              height: 108,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_banner_top.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(color: const Color(0xFF522328).withOpacity(0.3)),
                  const Positioned(
                    top: 47, left: 23,
                    child: Text("Hành trình đặc biệt!",
                        style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ],
              ),
            ),

            // --- USER INFO BOX ---
            Positioned(
              top: 105,
              left: 0, right: 0,
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 7,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Avatar (Sử dụng profile.avatarUrl nếu có)
                    Positioned(
                      left: 10, top: 9,
                      child: profile?.avatarUrl != null
                          ? CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(profile.avatarUrl))
                          : Image.asset('assets/images/img_avatar.png', width: 50, height: 50),
                    ),

                    // SỬA TẠI ĐÂY: Hiển thị fullName thực tế
                    Positioned(
                      left: 59,
                      top: 5,
                      child: Text(
                        "Hi . ${profile?.fullName ?? 'Khách'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Badge Hành Khách
                    Positioned(
                      left: 80, top: 29,
                      child: Container(
                        width: 80, height: 15,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        child: const Text("Hành Khách",
                            style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                      ),
                    ),

                    // Các icon và địa chỉ giữ nguyên...
                    Positioned(
                      left: 54, top: 25,
                      child: Image.asset('assets/icons/ic_star_black.png', width: 23, height: 23),
                    ),
                    Positioned(
                      left: 57, top: 50,
                      child: Row(
                        children: [
                          Image.asset('assets/icons/ic_location_pin.png', width: 17, height: 17),
                          const SizedBox(width: 6),
                          const Text("Thị trấn thường thới tiền . Hồng Ngự",
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black)),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 24, top: 22,
                      child: Image.asset('assets/icons/ic_arrow_right_circle.png', width: 30, height: 30),
                    ),
                  ],
                ),
              ),
            ),

            // Badge Ngày tháng
            Positioned(
              top: 18, left: 19,
              child: Container(
                width: 95, height: 20,
                decoration: BoxDecoration(color: const Color(0xFF321915), borderRadius: BorderRadius.circular(15)),
                alignment: Alignment.center,
                child: const Text("09.02 - 14.02",
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 85),
      ],
    );
  }
}