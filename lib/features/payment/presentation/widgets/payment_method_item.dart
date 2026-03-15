import 'package:flutter/material.dart';
import 'package:ghepxenew/core/theme/app_colors.dart';
import '../../domain/entities/payment_method.dart';

class PaymentMethodItem extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFlat;

  const PaymentMethodItem({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
    this.isFlat = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white, // Luôn là màu trắng tinh theo ý em
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            // Nếu chọn thì viền đen đậm, không chọn thì viền xám rất nhạt
            color: isSelected ? AppColors.black : const Color(0xFFF0F0F0),
            width: isSelected ? 2 : 1,
          ),
          // ĐỔ BÓNG RIÊNG CHO TỪNG BOX NHỎ
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.black.withOpacity(0.12) // Bóng đậm hơn khi được chọn
                  : Colors.black.withOpacity(0.05), // Bóng nhẹ khi chưa chọn
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                method.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Hiển thị ảnh logo
            Image.asset(
              method.icon,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              // Chỉnh filterQuality để ảnh bớt mờ khi scale
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.payment, size: 28, color: Colors.grey);
              },
            ),
          ],
        ),
      ),
    );
  }
}