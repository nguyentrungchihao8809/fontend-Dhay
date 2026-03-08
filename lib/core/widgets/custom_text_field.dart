import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final Widget? prefixIcon; // Dùng cho trang Login
  final Widget? suffixIcon; // Dùng cho cả hai
  final bool isUnderline;   // Biến quan trọng để phân biệt kiểu dáng
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isUnderline = false, // Mặc định là false để không làm lỗi trang cũ
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    if (isUnderline) {
      // --- KIỂU GẠCH CHÂN (Cho Register Driver) ---
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.black54, fontSize: 15),
            suffixIcon: suffixIcon ?? const Icon(Icons.add_circle_outline, size: 22),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );
    } else {
      // --- KIỂU BOX XÁM (Cho Login/Intro - Giữ nguyên code cũ của bạn) ---
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: prefixIcon != null
                ? Padding(padding: const EdgeInsets.all(12), child: prefixIcon)
                : null,
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      );
    }
  }
}