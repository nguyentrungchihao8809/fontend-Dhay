import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Header Section (Hi BauBau)
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            children: [
              Row(
                children: [
                  // Rectangle 405: Date Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.darkBrown,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text("09.02 - 14.02",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Image.asset('assets/images/img_avatar_placeholder.png', width: 50, height: 50),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, BauBau", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text("Thị trấn thường thới tiền, Hồng Ngự",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Spacer(),
                  Image.asset('assets/icons/ic_filter_menu.png', width: 30, height: 30),
                ],
              )
            ],
          ),
        ),
        // Rectangle 403: Search Bar Section
        Container(
          width: double.infinity,
          height: 75,
          decoration: const BoxDecoration(
            color: AppColors.searchBackground,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 7, offset: Offset(0, 4))],
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 17),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 47,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.lightGrey, width: 2.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Image.asset('assets/icons/ic_search.png', width: 25, height: 25),
                const SizedBox(width: 10),
                const Text("Bạn muốn đi đâu nào.....",
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}