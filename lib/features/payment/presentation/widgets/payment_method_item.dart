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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          // HIỆU ỨNG VIỀN KHI CHỌN
          border: Border.all(
            color: isSelected ? AppColors.black : Colors.transparent,
            width: 2,
          ),
          // HIỆU ỨNG ĐỔ BÓNG TỪNG ITEM
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.black.withOpacity(0.12) // Bóng đậm hơn khi chọn
                  : Colors.black.withOpacity(0.04), // Bóng rất nhẹ khi chưa chọn
              blurRadius: isSelected ? 15 : 8,
              offset: isSelected ? const Offset(0, 6) : const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                method.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            _buildMethodIcon(method.name),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodIcon(String name) {
    final n = name.toLowerCase();
    // Logic hiển thị Icon (như đã hướng dẫn ở các bước trước)
    if (n.contains('tiền')) return const Icon(Icons.payments_rounded, color: Colors.green, size: 28);
    if (n.contains('momo')) return const Icon(Icons.wallet, color: Colors.pink, size: 28);
    if (n.contains('zalo')) return const Icon(Icons.account_balance_wallet, color: Colors.blue, size: 28);
    if (n.contains('vnpay')) return const Icon(Icons.qr_code_scanner, color: Colors.red, size: 28);
    if (n.contains('vietqr')) return const Icon(Icons.qr_code, color: Colors.black, size: 28);
    return const Icon(Icons.payment);
  }
}