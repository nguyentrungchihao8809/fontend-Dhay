import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RecentTripCard extends StatelessWidget {
  const RecentTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.searchBackground),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          // Phần bản đồ preview sử dụng assets/images/maps
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/img_map_preview_sample.png', // Tên file ảnh bản đồ của bạn
              height: 70,
              width: double.infinity,
              fit: BoxFit.cover,
              // Xử lý lỗi nếu chưa có file trong folder assets
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 70,
                  color: AppColors.lightBlue,
                  child: const Center(child: Icon(Icons.map, color: Colors.blue)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _locationItem('assets/icons/ic_dot_outline.png', "Tiệm sửa xe Ngọc Sơn"),
          const SizedBox(height: 6),
          _locationItem('assets/icons/ic_location_pin.png', "Chợ Hồng Ngự"),
          const SizedBox(height: 12),

          // Button Đặt lại
          InkWell(
            onTap: () {
              // Placeholder cho BLoC event: context.read<HomeBloc>().add(RebookTripEvent());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      'assets/icons/ic_refresh.png',
                      width: 16,
                      height: 16,
                      color: Colors.white
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Đặt lại",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _locationItem(String iconPath, String label) {
    return Row(
      children: [
        Image.asset(iconPath, width: 14, height: 14),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}