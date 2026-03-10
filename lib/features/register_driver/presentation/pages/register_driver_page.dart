import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../register_driver/domain/entities/driver_registration.dart';
import '../../../register_driver/presentation/bloc/register_driver_bloc.dart';
import '../../../register_driver/presentation/bloc/register_driver_event.dart';
import '../../../register_driver/presentation/bloc/register_driver_state.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // --- 6 CONTROLLERS KHỚP DTO JAVA ---
  final _licenseNumberController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _capacityController = TextEditingController();

  String? _selectedBrand;
  String? _selectedType = "MOTORBIKE"; // Mặc định Enum Java

  final List<String> _brands = ["Honda", "Yamaha", "Suzuki", "VinFast", "Toyota", "Khác"];
  final List<Map<String, String>> _types = [
    {"value": "MOTORBIKE", "label": "Xe máy"},
    {"value": "CAR_4_SEATER", "label": "Ô tô 4 chỗ"},
    {"value": "CAR_7_SEATER", "label": "Ô tô 7 chỗ"},
  ];

  @override
  void dispose() {
    _licenseNumberController.dispose();
    _vehiclePlateController.dispose();
    _vehicleModelController.dispose();
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
              const SnackBar(content: Text("Chúc mừng tân tài xế!"), backgroundColor: Colors.green),
            );
            // Sau khi đăng ký xong, đẩy về Home Driver
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
              _buildFormCard(),
              const SizedBox(height: 30),
              Text("From DHAY", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 40),
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
            child: Text("D", style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
        ),
        Text("Đăng ký trở thành Driver",
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 1. Số bằng lái
            _underlineInput("Số bằng lái", _licenseNumberController),

            // 2. Biển số xe (Regex chuẩn 29A-12345)
            _underlineInput("Biển số xe (VD: 29A-12345)", _vehiclePlateController,
                pattern: r'^[0-9]{2}[A-Z]-[0-9]{4,5}$'),

            // 3. Hãng xe (Dropdown)
            _underlineDropdown("Hãng xe", _brands, (v) => setState(() => _selectedBrand = v)),

            // 4. Loại xe (Dropdown Enum)
            _underlineDropdown("Loại xe", _types.map((e) => e['label']!).toList(), (label) {
              setState(() {
                _selectedType = _types.firstWhere((e) => e['label'] == label)['value'];
              });
            }),

            // 5. Dòng xe
            _underlineInput("Dòng xe (Vision, Vios...)", _vehicleModelController),

            // 6. Số ghế trống
            _underlineInput("Số ghế trống", _capacityController, isNumber: true),

            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET INPUT GẠCH CHÂN ---
  Widget _underlineInput(String hint, TextEditingController ctrl, {bool isNumber = false, String? pattern}) {
    return Column(
      children: [
        TextFormField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.poppins(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
            suffixIcon: const Icon(Icons.add_circle_outline, color: Colors.black38, size: 20),
            border: InputBorder.none,
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return "Bắt buộc nhập";
            if (pattern != null && !RegExp(pattern).hasMatch(v)) return "Sai định dạng";
            return null;
          },
        ),
        const Divider(height: 1, color: Colors.black12),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _underlineDropdown(String hint, List<String> items, Function(String?) onChanged) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
            border: InputBorder.none,
            suffixIcon: const Icon(Icons.add_circle_outline, color: Colors.black38, size: 20),
          ),
          icon: const SizedBox.shrink(), // Ẩn icon mặc định để dùng suffixIcon
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          validator: (v) => v == null ? "Bắt buộc chọn" : null,
        ),
        const Divider(height: 1, color: Colors.black12),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<RegisterDriverBloc, RegisterDriverState>(
      builder: (context, state) {
        if (state is RegisterDriverLoading) return const CircularProgressIndicator(color: Colors.black);

        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedBrand != null) {
              // GỬI SỰ KIỆN LÊN BLOC
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
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: Text("Hoàn tất đăng ký",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}