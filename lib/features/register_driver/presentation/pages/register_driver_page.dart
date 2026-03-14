import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  final _formKey = GlobalKey<FormState>();
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildLogo(),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Đăng ký trở thành Driver",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: _buildFormCard(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        alignment: Alignment.center,
        child: _buildFooter(),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "D",
              style: GoogleFonts.poppins(
                fontSize: 55,
                fontWeight: FontWeight.w900,
                height: 1.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF4285F4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.5),
                ),
              ),
            ),
          ],
        ),
        Text(
          "DHAY",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            height: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCFF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD9D9D9),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Text(
                    "Chào mừng bạn đến với DHAY với vai trò tài xế",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Vui lòng đảm bảo thông tin chính xác, tuân thủ luật giao thông và luôn giữ thái độ thân thiện với hành khách.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _underlineInput("Số bằng lái", _licenseNumberController),
            _underlineInput("Biển số xe", _vehiclePlateController),
            _underlineDropdown("Hãng xe", _brands, (v) => setState(() => _selectedBrand = v)),
            _underlineDropdown("Loại xe", _types.map((e) => e['label']!).toList(), (label) {
              setState(() {
                _selectedType = _types.firstWhere((e) => e['label'] == label)['value'];
              });
            }),
            _underlineInput("Dòng xe", _vehicleModelController),
            _underlineInput("Số ghế trống", _capacityController, isNumber: true),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _underlineInput(String hint, TextEditingController ctrl, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          TextFormField(
            controller: ctrl,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: InputBorder.none,
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
        ],
      ),
    );
  }

  Widget _underlineDropdown(String hint, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: InputBorder.none,
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black26),
            items: items.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: GoogleFonts.poppins(fontSize: 14))
            )).toList(),
            onChanged: onChanged,
          ),
          const Divider(height: 1, color: Colors.black12),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Logic submit
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(220, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 6,
      ),
      child: Text(
          "Đăng ký",
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
          )
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "From ",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)
        ),
        Text(
            "DHAY",
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4285F4)
            )
        ),
      ],
    );
  }
}
//...