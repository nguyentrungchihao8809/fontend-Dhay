import 'package:flutter/material.dart';

class RecentTripCard extends StatelessWidget {
  const RecentTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260, // Giữ cố định width theo CSS để cuộn ngang không lỗi
      margin: const EdgeInsets.only(right: 16, bottom: 10, top: 5, left: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Bản đồ (Phần ảnh trên cùng)
          Container(
            height: 72,
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/img_map_sample.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey, size: 24),
                  );
                },
              ),
            ),
          ),

          // 2. Lịch trình (Điểm đi - Điểm đến)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationRow(Icons.circle, "Tiệm sửa xe Ngọc Sơn", size: 10),

                  // Đường kẻ dọc kết nối
                  Container(
                    width: 2,
                    height: 16, // Độ dài vừa phải để không chạm icon
                    margin: const EdgeInsets.only(left: 5.5, top: 2, bottom: 2),
                    color: Colors.black,
                  ),

                  _buildLocationRow(Icons.location_on, "Chợ Hồng Ngự", size: 14),
                ],
              ),
            ),
          ),

          // 3. Nút Đặt lại (Rectangle 387)
          Container(
            width: 210,
            height: 35,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Material( // Thêm Material để có hiệu ứng nhấn (Inkwell)
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/ic_refresh.png',
                      width: 18,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.refresh, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Đặt lại",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String label, {double size = 14}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 13,
          child: Center(child: Icon(icon, size: size, color: Colors.black)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}