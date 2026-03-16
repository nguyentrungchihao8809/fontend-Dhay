import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_text_field.dart'; // ĐẢM BẢO ĐÚNG DÒNG NÀY

class LocationInputSection extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController destinationController;
  final VoidCallback onSwap;

  const LocationInputSection({
    super.key,
    required this.pickupController,
    required this.destinationController,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Stack(
        alignment: Alignment.centerRight,
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              CustomTextField(
                controller: pickupController,
                hintText: 'Điểm đón...',
                prefixIcon: const Icon(Icons.radio_button_checked, color: Colors.black, size: 20),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: destinationController,
                hintText: 'Điểm đến...',
                prefixIcon: const Icon(Icons.location_on, color: Colors.black, size: 20),
              ),
            ],
          ),
          Positioned(
            right: -15,
            child: GestureDetector(
              onTap: onSwap,
              child: const Icon(Icons.swap_vert, size: 35, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}