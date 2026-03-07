import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LocationInputField extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged; // THÊM DÒNG NÀY

  const LocationInputField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.onChanged, // THÊM DÒNG NÀY
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged, // KẾT NỐI VÀO ĐÂY
        style: const TextStyle(
          color: AppColors.textMain,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          icon: prefixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.textSub,
            fontFamily: 'Poppins',
          ),
          border: InputBorder.none,
          suffixIcon: const Icon(Icons.search, color: AppColors.black),
        ),
      ),
    );
  }
}