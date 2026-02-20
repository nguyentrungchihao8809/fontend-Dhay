import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // --- PHẦN BANNER NỀN (Nằm dưới cùng) ---
            Container(
              width: double.infinity,
              height: 108, // image 566
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_banner_top.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Lớp phủ màu (Rectangle 399)
                  Container(color: const Color(0xFF522328).withOpacity(0.3)),
                  // Nội dung text trên banner
                  const Positioned(
                    top: 47, left: 23,
                    child: Text("Hành trình đặc biệt!",
                        style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ],
              ),
            ),

            // --- USER INFO BOX (Rectangle 403 - Bo 2 góc dưới + Bóng đổ) ---
            Positioned(
              top: 105, // Theo CSS: top 105px
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
                    // Avatar (image 571) - Left 10px, Top 114px (so với tổng thể)
                    Positioned(
                      left: 10, top: 9, // Tính toán lại offset trong box
                      child: Image.asset('assets/images/img_avatar.png', width: 50, height: 50),
                    ),
                    // Hi . BauBau (Left 59, Top 110)
                    const Positioned(
                      left: 59, top: 5,
                      child: Text("Hi . BauBau",
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
                    ),
                    // Badge Hành Khách (Rectangle 404 + Text)
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
                    // Icon Star (Star 31)
                    Positioned(
                      left: 54, top: 25,
                      child: Image.asset('assets/icons/ic_star_black.png', width: 23, height: 23),
                    ),
                    // Địa chỉ (Thị trấn... + image 570)
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
                    // Icon mũi tên bên phải (image 298)
                    Positioned(
                      right: 24, top: 22,
                      child: Image.asset('assets/icons/ic_arrow_right_circle.png', width: 30, height: 30),
                    ),
                  ],
                ),
              ),
            ),

            // Badge Ngày tháng (Rectangle 405) - Nằm trên cùng banner
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

        // Khoảng cách để đẩy phần nội dung bên dưới xuống (vì Box trên dùng Positioned)
        const SizedBox(height: 85),

        // --- THANH TÌM KIẾM (Rectangle 397 - CÓ THỂ NHẤN ĐƯỢC) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: GestureDetector(
            onTap: () {
              print("Mở màn hình tìm kiếm...");
              // Navigator.push(context, ...);
            },
            child: Container(
              width: 380,
              height: 47,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD9D9D9), width: 2.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 17),
                  Image.asset('assets/icons/ic_search.png', width: 25, height: 25), // image 567
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Bạn muốn đi đâu nào.....",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB9B9B9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}