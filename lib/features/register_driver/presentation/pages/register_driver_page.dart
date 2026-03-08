// lib/features/register_driver/presentation/pages/register_driver_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/driver_registration.dart';
import '../bloc/register_driver_bloc.dart';
import '../bloc/register_driver_event.dart';
import '../bloc/register_driver_state.dart';

// ĐỔI TÊN CLASS THÀNH DriverRegistrationScreen
class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // 6 Controllers khớp hoàn toàn DriverRegistrationRequest bên Java
  final _licenseNumberController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _capacityController = TextEditingController();
  String? _selectedBrand;
  String? _selectedType = "MOTORBIKE";

  final List<String> _brands = ["Honda", "Yamaha", "Suzuki", "VinFast", "Toyota", "Khác"];
  final List<Map<String, String>> _types = [
    {"value": "MOTORBIKE", "label": "Xe máy"},
    {"value": "CAR_4_SEATER", "label": "Ô tô 4 chỗ"},
    {"value": "CAR_7_SEATER", "label": "Ô tô 7 chỗ"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ĐĂNG KÝ TÀI XẾ MỚI", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<RegisterDriverBloc, RegisterDriverState>(
        listener: (context, state) {
          if (state is RegisterDriverSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thành công!")));
            Navigator.pushNamedAndRemoveUntil(context, '/home_driver', (route) => false);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildInput("Số bằng lái (licenseNumber)", _licenseNumberController),
                _buildInput("Biển số xe (vehiclePlate)", _vehiclePlateController, pattern: r'^[0-9]{2}[A-Z]-[0-9]{4,5}$'),
                _buildDropdown("Hãng xe (vehicleBrand)", _brands, (v) => _selectedBrand = v),
                _buildDropdown("Loại xe (vehicleType)", _types.map((e) => e['label']!).toList(), (label) {
                  _selectedType = _types.firstWhere((e) => e['label'] == label)['value'];
                }),
                _buildInput("Dòng xe (vehicleModel)", _vehicleModelController),
                _buildInput("Sức chứa (capacity)", _capacityController, isNumber: true),
                const SizedBox(height: 40),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController ctrl, {bool isNumber = false, String? pattern}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.edit_note),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return "Bắt buộc nhập";
          if (pattern != null && !RegExp(pattern).hasMatch(v)) return "Sai định dạng";
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: hint, border: const OutlineInputBorder()),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? "Bắt buộc chọn" : null,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate() && _selectedBrand != null) {
          context.read<RegisterDriverBloc>().add(OnRegisterSubmit(DriverRegistration(
            licenseNumber: _licenseNumberController.text,
            vehiclePlate: _vehiclePlateController.text,
            vehicleBrand: _selectedBrand!,
            capacity: int.parse(_capacityController.text),
            vehicleType: _selectedType!,
            vehicleModel: _vehicleModelController.text,
          )));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text("HOÀN TẤT ĐĂNG KÝ", style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}