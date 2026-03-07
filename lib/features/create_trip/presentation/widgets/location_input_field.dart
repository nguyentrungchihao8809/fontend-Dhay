import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_trip_bloc.dart';

class LocationInputField extends StatefulWidget {
  const LocationInputField({super.key});

  @override
  State<LocationInputField> createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Lắng nghe State để cập nhật chữ vào ô input khi chọn xong
    return BlocListener<CreateTripBloc, CreateTripState>(
      listener: (context, state) {
        if (state is CreateTripLoaded) {
          if (state.selectedPickup != null) {
            _pickupController.text = state.selectedPickup!.address;
          }
          if (state.selectedDropoff != null) {
            _dropoffController.text = state.selectedDropoff!.address;
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            _buildIconLine(),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                children: [
                  _buildField(_pickupController, "Bạn muốn đi đâu....", LocationFieldType.pickup),
                  const Divider(color: Color(0xFFF2F2F2), thickness: 1),
                  _buildField(_dropoffController, "Bạn muốn đến đâu....", LocationFieldType.dropoff),
                ],
              ),
            ),
            const Icon(Icons.swap_vert, size: 28, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, LocationFieldType type) {
    return TextField(
      controller: controller, // Gắn controller vào đây
      onChanged: (value) => context.read<CreateTripBloc>().add(SearchQueryChanged(value, type)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Poppins', color: Color(0xFFD9D9D9)),
        border: InputBorder.none,
        isDense: true,
      ),
    );
  }

  Widget _buildIconLine() {
    return Column(
      children: [
        const Icon(Icons.radio_button_checked, size: 20, color: Colors.black),
        Container(width: 2, height: 26, color: const Color(0xFFB9B9B9)),
        const Icon(Icons.location_on, size: 20, color: Colors.black),
      ],
    );
  }
}