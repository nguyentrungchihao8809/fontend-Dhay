// lib/features/register_driver/presentation/pages/register_driver_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/driver_registration.dart';
import '../bloc/register_driver_bloc.dart';
import '../bloc/register_driver_event.dart';
import '../bloc/register_driver_state.dart';

class RegisterDriverPage extends StatefulWidget {
  const RegisterDriverPage({super.key});

  @override
  State<RegisterDriverPage> createState() => _RegisterDriverPageState();
}

class _RegisterDriverPageState extends State<RegisterDriverPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _licenseController = TextEditingController();
  final _plateController = TextEditingController();
  final _modelController = TextEditingController();
  final _capacityController = TextEditingController();

  // Selection Data
  String? _selectedType = "MOTORBIKE";
  String? _selectedBrand;

  final List<Map<String, String>> _vehicleTypes = [
    {"value": "MOTORBIKE", "label": "Xe máy", "max": "1"},
    {"value": "CAR_4_SEATER", "label": "Ô tô 4 chỗ", "max": "3"},
    {"value": "CAR_7_SEATER", "label": "Ô tô 7 chỗ", "max": "6"},
  ];

  final List<String> _brands = [
    "Honda", "Yamaha", "Piaggio/Vespa", "Suzuki", "SYM", "VinFast", "Khác"
  ];

  @override
  void dispose() {
    _licenseController.dispose();
    _plateController.dispose();
    _modelController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<RegisterDriverBloc, RegisterDriverState>(
        listener: (context, state) {
          if (state is RegisterDriverSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Chào mừng bác tài mới!"), backgroundColor: Colors.green),
            );
            Navigator.pushNamedAndRemoveUntil(context, '/home_driver', (route) => false);
          } else if (state is RegisterDriverFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  _buildMainCard(),
                  _buildAvatarCircle(),
                ],
              ),
              const SizedBox(height: 20),
              Text("From DHAY", style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Container(
              width: 80, height: 40,
              child: const Icon(Icons. car_rental, size: 40), // Thay bằng Image.asset nếu có logo
            ),
          ),
        ),
        Text(
          "Đăng ký trở thành Driver",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildMainCard() {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: 32, right: 32, bottom: 20),
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 30),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 4, offset: const Offset(0, 4)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildWelcomeBox(),
            const SizedBox(height: 10),

            // --- Input Fields chuẩn Underline Figma ---
            _buildUnderlineInput("Số bằng lái", _licenseController),
            _buildUnderlineInput("Biển số xe (VD: 29A-12345)", _plateController, regExp: r'^[0-9]{2}[A-Z]-[0-9]{4,5}$'),

            _buildUnderlineDropdown("Hãng xe", _brands, _selectedBrand, (val) => setState(() => _selectedBrand = val)),

            _buildUnderlineDropdown("Loại xe", _vehicleTypes.map((e) => e['label']!).toList(),
                _vehicleTypes.firstWhere((e) => e['value'] == _selectedType)['label'],
                    (val) {
                  setState(() {
                    _selectedType = _vehicleTypes.firstWhere((e) => e['label'] == val)['value'];
                    _capacityController.clear();
                  });
                }
            ),

            _buildUnderlineInput("Dòng xe (Vision, Exciter...)", _modelController),
            _buildUnderlineInput("Số ghế trống", _capacityController, isNumber: true),

            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET TẠO INPUT GẠCH CHÂN CHUẨN FIGMA ---
  Widget _buildUnderlineInput(String hint, TextEditingController ctrl, {bool isNumber = false, String? regExp}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.black.withOpacity(0.4), fontSize: 16),
        suffixIcon: const Icon(Icons.add_circle_outline, color: Colors.black54, size: 20),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Không được để trống";
        if (regExp != null && !RegExp(regExp).hasMatch(value)) return "Định dạng không hợp lệ";
        if (isNumber) {
          final max = _vehicleTypes.firstWhere((e) => e['value'] == _selectedType)['max'];
          final val = int.tryParse(value);
          if (val == null || val < 1 || val > int.parse(max!)) return "Tối đa $max chỗ";
        }
        return null;
      },
    );
  }

  // --- WIDGET TẠO DROPDOWN GẠCH CHÂN CHUẨN FIGMA ---
  Widget _buildUnderlineDropdown(String hint, List<String> items, String? currentVal, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: currentVal,
      icon: const Icon(Icons.add_circle_outline, color: Colors.black54, size: 20),
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.black.withOpacity(0.4), fontSize: 16),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? "Vui lòng chọn" : null,
    );
  }

  Widget _buildWelcomeBox() {
    return Column(
      children: [
        Text(
          "Chào mừng bạn đến với DHAY với vai trò tài xế",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 5),
        Text(
          "Vui lòng đảm bảo thông tin phương tiện chính xác, tuân thủ luật giao thông...",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<RegisterDriverBloc, RegisterDriverState>(
      builder: (context, state) {
        if (state is RegisterDriverLoading) return const CircularProgressIndicator(color: Colors.black);
        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<RegisterDriverBloc>().add(OnRegisterSubmit(DriverRegistration(
                licenseNumber: _licenseController.text,
                vehiclePlate: _plateController.text,
                vehicleBrand: _selectedBrand ?? "Khác",
                capacity: int.parse(_capacityController.text),
                vehicleType: _selectedType!,
                vehicleModel: _modelController.text,
              )));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(243, 45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5,
          ),
          child: Text("Đăng ký", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        );
      },
    );
  }

  Widget _buildAvatarCircle() {
    return Container(
      width: 130, height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(4, 4), blurRadius: 4)],
      ),
      child: const Icon(Icons.person, size: 80, color: Colors.white),
    );
  }
}