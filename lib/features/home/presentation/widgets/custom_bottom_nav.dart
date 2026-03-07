import 'package:flutter/material.dart';
import '../../../../features/auth/presentation/pages/profile_page.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 19, right: 19),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2, spreadRadius: 2, offset: Offset(2, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/icons/ic_nav_notification.png', width: 37, height: 37),
          Image.asset('assets/icons/ic_nav_history.png', width: 42, height: 42),
          // Active Home Indicator (Rectangle 308)
          Container(
            width: 85,
            height: 52,
            decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(25)),
            child: Center(child: Image.asset('assets/icons/ic_nav_home_active.png', width: 39, height: 39)),
          ),
          Image.asset('assets/icons/ic_nav_gift.png', width: 37, height: 37),
          // Nút Profile với Navigation
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: Image.asset(
                'assets/icons/ic_nav_profile.png',
                width: 35,
                height: 35
            ),
          ),
          ],
      ),
    );
  }
}