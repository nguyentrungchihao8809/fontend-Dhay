import 'package:flutter/material.dart';

class AppColors {
  // 1. Màu hệ thống & Nền (System & Background)
  static const Color primary = Color(0xFF395BFC);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFEFCFF); // Đã fix trùng tên
  static const Color secondaryBackground = Color(0xFFF4F5F5);
  static const Color inputBackground = Color(0xFFE0E0E0);

  // 2. Màu chữ (Text Colors)
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textGrey = Color(0xFF757575);
  static const Color textLightGrey = Color(0xFFB9B9B9);

  // 3. Màu cho Driver & Home Page (Theo thiết kế của cưng)
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color accentYellow = Color(0xFFFFC107); // Đã fix trùng tên
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color storyYellow = Color(0xFFFFD700);

  // 4. Navigation Bar & Buttons
  static const Color navBackground = Color(0xFF0D0D0D);
  static const Color navActiveItem = Color(0xFFF2F2F2);
  static const Color darkPrimary = Color(0xFF101012);
  static const Color logoutBtnBackground = Color(0xFF0F0E0E);

  // 5. Đường kẻ & Đổ bóng (Lines & Shadows)
  static const Color divider = Color(0xFFD9D9D9);
  static const Color lineBlack = Color(0xFF000000);
  static const Color cardShadow = Color(0x1A000000);
  static const Color shadowColor = Color(0x40000000);
  static const Color lightShadow = Color(0x0D000000);

  // 6. Các màu bổ trợ khác
  static const Color starRating = Color(0xFFFFBF00);
  static const Color darkBrown = Color(0xFF321915);
  static const Color lightGrey = Color(0xFFD9D9D9);

  // Thêm lại các biến này để fix lỗi ở các trang cũ
  static const Color greyText = Color(0xFF757575);
  static const Color lineDivider = Color(0xFFD9D9D9);
  static const Color primaryText = Color(0xFF000000);
}