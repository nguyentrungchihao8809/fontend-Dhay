import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF395BFC);
  static const Color black = Color(0xFF000000);

  // Sửa lại dòng này:
  static const Color greyText = Color(0xFF757575);

  static const Color background = Color(0xFFF5F5F5);
  static const Color inputBackground = Color(0xFFE0E0E0);

  //home_page
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color accentYellow = Color(0xFFFFD700);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color greyBackground = Color(0xFFF5F5F5);
  static const Color textGrey = Color(0xFF757575);
  static const Color cardShadow = Color(0x1A000000);

  // Màu chủ đạo (Primary Colors)
  static const Color searchBackground = Color(0xFFF4F5F5);
  static const Color primaryBackground = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFF4F5F5); // Rectangle 403
  // Rectangle 251 (Dhay Story)
  static const Color darkPrimary = Color(0xFF101012); // Buttons, Rectangle 250

  // Màu chữ (Text Colors)
  static const Color textBlack = Color(0xFF000000);
  static const Color textWhite = Color(0xFFFFFFFF);
  // Thêm dòng này vào trong class AppColors
  static const Color storyYellow = accentYellow;
  // 22-01-2026 text
  static const Color textLightGrey = Color(0xFFB9B9B9); // Time & Distance text

  // Màu đường kẻ và viền (Lines & Borders)
  static const Color lineGrey = Color(0xFFB9B9B9); // Line 72, 115, 116
  static const Color lineBlack = Color(0xFF000000); // Line 108, 109, 110

  // Màu trạng thái & Hiệu ứng (Status & Effects)
  static const Color shadowColor = Color(0x40000000); // rgba(0, 0, 0, 0.25)
  static const Color lightShadow = Color(0x0D000000); // rgba(0, 0, 0, 0.05)
  static const Color navGrey = Color(0xFFF2F2F2); // Rectangle 308 (Bottom Nav item)

  // Gradient hoặc Overlay (nếu cần)
  static const Color overlayGrey = Color(0x26D9D9D9);

  static Color? get lightBlue => null; // rgba(217, 217, 217, 0.15)
  static const Color darkBrown = Color(0xFF321915);
  static const Color lightGrey = Color(0xFFD9D9D9);
}