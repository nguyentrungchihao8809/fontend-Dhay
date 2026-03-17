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
        color: Colors.white, // Đã là màu trắng
        borderRadius: BorderRadius.circular(30),
        // Nếu muốn ô trắng trông sạch hơn, bạn có thể chỉnh border mỏng lại hoặc đổi màu
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 15, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          // ĐỔI MÀU Ở ĐÂY: Chỉnh từ Color(0xFF8E8E8E) sang Colors.black
          hintStyle: const TextStyle(
              color: Colors.black, // Chữ "Điểm đón", "Điểm đến" sẽ thành màu đen
              fontSize: 14,
              fontWeight: FontWeight.w500 // Có thể thêm đậm một chút cho rõ
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: prefixIcon,
          ),
          suffixIcon: suffixIcon ?? const Icon(Icons.search, color: Colors.black, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}