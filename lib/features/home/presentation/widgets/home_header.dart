import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final dynamic profile;

  const HomeHeader({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // --- 1. BANNER NỀN ---
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

            // --- 2. USER INFO BOX ---
            Positioned(
              top: 105,
              left: 0, right: 0,
              child: Container(
                height: 80, // Tăng nhẹ chiều cao cho thoải mái
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: Stack(
                  children: [
                    // --- AVATAR SIÊU NÉT ---
                    Positioned(
                      left: 15, top: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: profile?.avatarUrl != null
                              ? NetworkImage(profile.avatarUrl)
                              : null,
                          child: profile?.avatarUrl == null
                              ? const Icon(Icons.person, color: Colors.white, size: 30)
                              : null,
                        ),
                      ),
                    ),

                    // Tên User
                    Positioned(
                      left: 75, top: 10,
                      child: Text(
                        "Hi . ${profile?.fullName ?? 'BauBau'}",
                        style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),
                      ),
                    ),

                    // --- CĂN HÀNG NGÔI SAO & BADGE ---
                    Positioned(
                      left: 72, top: 32, // Chỉnh left lại một chút cho ngay hàng
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.black, size: 18),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                            child: const Text("Hành Khách",
                                style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),

                    // --- CĂN HÀNG ĐỊNH VỊ (Thẳng hàng dọc với Ngôi sao) ---
                    Positioned(
                      left: 72, top: 55, // Top 55 để cách đều hàng trên
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.black),
                          const SizedBox(width: 4),
                          const Text(
                            "Thị trấn thường thới tiền . Hồng Ngự",
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    // Mũi tên chuyển trang
                    Positioned(
                      right: 20, top: 24,
                      child: Container(
                        width: 32, height: 32,
                        decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                        child: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badge Ngày tháng
            Positioned(
              top: 18, left: 19,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF321915), borderRadius: BorderRadius.circular(15)),
                child: const Text("09.02 - 14.02",
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 90),
      ],
    );
  }
}