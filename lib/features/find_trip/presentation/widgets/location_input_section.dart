import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_text_field.dart';

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
    return Stack(
      children: [
        Column(
          children: [
            // Ô nhập Điểm đón (Figma top: 148px)
            CustomTextField(
              controller: pickupController,
              hintText: 'Điểm đón...',
              prefixIcon: _buildPickupIcon(),
            ),
            const SizedBox(height: 16), // Khoảng cách giữa 2 ô (213 - 148 - 49)
            // Ô nhập Điểm đến (Figma top: 213px)
            CustomTextField(
              controller: destinationController,
              hintText: 'Điểm đến...',
              prefixIcon: const Icon(Icons.location_on, color: Colors.black, size: 30),
            ),
          ],
        ),
        // Nút Hoán đổi vị trí (Swap)
        Positioned(
          right: -10,
          top: 35,
          child: IconButton(
            onPressed: onSwap,
            icon: const Icon(
              Icons.swap_vert,
              size: 35,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickupIcon() {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}