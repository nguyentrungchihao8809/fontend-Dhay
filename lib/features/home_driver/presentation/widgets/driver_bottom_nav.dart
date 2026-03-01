import 'package:flutter/material.dart';
import 'package:ghepxenew/core/theme/app_colors.dart';

class DriverBottomNav extends StatefulWidget {
  const DriverBottomNav({super.key});

  @override
  State<DriverBottomNav> createState() => _DriverBottomNavState();
}

class _DriverBottomNavState extends State<DriverBottomNav> {
  int _selectedIndex = 2;

  final List<IconData> _icons = [
    Icons.notifications_none_rounded,
    Icons.assignment_outlined,
    Icons.home_filled,
    Icons.bar_chart_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. VỊ TRÍ: Giữ nguyên margin cũ của cưng
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),

      // 2. CHIỀU CAO: Giữ nguyên 65px
      height: 65,

      decoration: BoxDecoration(
        color: AppColors.navBackground,
        // 3. ĐỘ BO GÓC: Giữ nguyên 30
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        children: [
          // 4. CỤC TRẮNG (Indicator): Chạy theo index
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            alignment: Alignment((_selectedIndex - 2) * 0.5, 0),
            child: Container(
              width: 80,
              height: 65,
              decoration: BoxDecoration(
                color: AppColors.navActiveItem,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          // 5. CÁC ICON: Giữ nguyên cấu trúc Row và Padding
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_icons.length, (index) {
                // Kiểm tra xem icon này có đang được chọn hay không
                bool isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 50,
                    child: Center(
                      // Thêm hiệu ứng chuyển động mượt mà khi đổi size
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _icons[index],
                          // LOGIC MỚI: Chọn thì size 36, không chọn thì size 26
                          size: isSelected ? 45 : 35,
                          color: isSelected
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}