import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1.2),
        boxShadow: [
          BoxShadow(
            // Sửa cảnh báo vàng bằng cách dùng withAlpha hoặc withValues
            color: Colors.black.withAlpha(26), // 26 tương đương với 10% opacity
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 15, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF8E8E8E), fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: prefixIcon,
          ),
          // Mặc định là kính lúp cho trang FindTrip
          suffixIcon: suffixIcon ?? const Icon(Icons.search, color: Colors.black, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}