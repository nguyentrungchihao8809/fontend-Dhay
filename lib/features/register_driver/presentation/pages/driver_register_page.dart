import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart'; // Import đúng file trên nha
import '../bloc/register_driver_bloc.dart';
import '../bloc/register_driver_event.dart';
import '../bloc/register_driver_state.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _idCardCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  String _selectedType = 'MOTORBIKE';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobCtrl.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 15),
                            _buildHeader(),
                            SizedBox(height: screenHeight * 0.02),
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 55),
                                  child: _buildInfoBox(context),
                                ),
                                _buildAvatar(),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 10),
                          child: _buildFooter(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset('assets/images/logo_dhay.png', height: 40, errorBuilder: (c, e, s) => const Icon(Icons.apps)),
        ),
        const SizedBox(height: 10),
        const Text(
          'Đăng ký trở thành Driver',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Poppins', color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.primary, width: 3.5),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: const CircleAvatar(
        backgroundColor: AppColors.white,
        child: Icon(Icons.person, size: 75, color: AppColors.primary),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 65, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 25, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWelcomeBanner(),
          const SizedBox(height: 15),
          _buildInput("Họ và tên", _nameCtrl),
          _buildInput("Ngày sinh", _dobCtrl, isDate: true),
          _buildInput("Nhập biển số xe", _plateCtrl),
          _buildInput("Nhập số CCCD", _idCardCtrl),
          _buildInput("Dòng xe (vehicleModel)", _modelCtrl),
          const SizedBox(height: 20),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.infoBoxBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Vui lòng đảm bảo thông tin phương tiện chính xác và giữ thái độ thân thiện với hành khách.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.4),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController ctrl, {bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 45,
        child: TextField(
          controller: ctrl,
          readOnly: isDate,
          onTap: isDate ? () => _selectDate(context) : null,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.add_circle_outline, color: AppColors.textGrey, size: 18),
              onPressed: isDate ? () => _selectDate(context) : null,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 1.2)),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<RegisterDriverBloc, RegisterDriverState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state is! RegisterDriverLoading) {
              context.read<RegisterDriverBloc>().add(RegisterDriverSubmitted(
                licenseNumber: _dobCtrl.text,
                vehiclePlate: _plateCtrl.text,
                vehicleBrand: _nameCtrl.text,
                vehicleModel: _modelCtrl.text,
                capacity: 4,
                vehicleType: _selectedType,
              ));
            }
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            alignment: Alignment.center,
            child: state is RegisterDriverLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                : const Text('Đăng ký', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return RichText(
      text: const TextSpan(
        text: 'From ',
        style: TextStyle(color: AppColors.textGrey, fontSize: 11, fontFamily: 'Poppins'),
        children: [
          TextSpan(text: 'DHAY', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}