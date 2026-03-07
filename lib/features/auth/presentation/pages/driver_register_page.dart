import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _plateController.dispose();
    _idCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // Giữ layout cố định xinh đẹp nè cưng iu ơi
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              _buildLeftHeader(),

              const Spacer(flex: 1),

              Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Lớp dưới: Box trắng chứa form cực xịn
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0, left: 24, right: 24),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildWelcomeBox(),
                          const SizedBox(height: 20),

                          CustomTextField(hintText: "Họ và tên", controller: _fullNameController),
                          const SizedBox(height: 10), // Tăng khoảng cách nhẹ cho thoáng
                          CustomTextField(hintText: "Ngày sinh", controller: _dobController),
                          const SizedBox(height: 10),
                          CustomTextField(hintText: "Nhập biển số xe", controller: _plateController),
                          const SizedBox(height: 10),
                          CustomTextField(hintText: "Nhập số căn cước công dân", controller: _idCardController),

                          const SizedBox(height: 25),
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),

                  _buildAvatarCircle(), // Avatar nằm phía trên cực nghệ
                ],
              ),

              const Spacer(flex: 2),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo đã bỏ dấu chấm xanh theo ý cưng iu ơi rồi nhé
                const Text(
                  "D",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),
                const Text(
                  "DHAY",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              "Đăng ký trở thành Driver",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCircle() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: const Icon(Icons.person, size: 60, color: Colors.grey),
    );
  }

  Widget _buildWelcomeBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50, // Đổi sang xám nhẹ cho thanh lịch
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            "Chào mừng bạn đến với DHAY với vai trò tài xế",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
          ),
          const SizedBox(height: 6),
          const Text(
            "Vui lòng đảm bảo thông tin phương tiện chính xác, tuân thủ luật giao thông và luôn giữ thái độ thân thiện với hành khách. Cùng DHAY mang đến những chuyến đi an toàn và đáng tin cậy.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Logic đăng ký của cưng iu ơi nằm ở đây nè
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text(
          "Đăng ký",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Text.rich(
        TextSpan(
          text: "From ",
          style: TextStyle(color: Colors.grey, fontSize: 12),
          children: [
            TextSpan(
              text: "DHAY",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}