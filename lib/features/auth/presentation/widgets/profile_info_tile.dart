import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool showArrow;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              if (showArrow)
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 1.5, color: AppColors.lineDivider),
        ],
      ),
    );
  }
}