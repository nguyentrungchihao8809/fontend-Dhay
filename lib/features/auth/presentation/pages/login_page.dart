import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghepxenew/features/auth/presentation/pages/driver_register_page.dart'; // Đã khớp tên file mới

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/social_login_button.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Chào mừng ${state.user.fullName}!"),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
                  (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/logo_dhay.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Đăng nhập vào DHAY",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Chào mừng bạn quay lại! Vui lòng nhập thông tin tài khoản.",
                  style: TextStyle(
                    color: AppColors.greyText,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  controller: _identifierController,
                  hintText: "Nhập tên đăng nhập",
                  prefixIcon: const Icon(Icons.account_circle, size: 28),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Nhập mật khẩu",
                  prefixIcon: const Icon(Icons.lock, size: 28),
                  isPassword: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Quên mật khẩu? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Đặt lại",
                          style: TextStyle(
                            color: Color(0xFF2A5EE1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: 200,
                    height: 56,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                            context.read<AuthBloc>().add(
                              LoginSubmitted(
                                _identifierController.text.trim(),
                                _passwordController.text.trim(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                              : const Text("Đăng nhập",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                SocialLoginButton(
                  text: "Đăng nhập bằng Google",
                  iconPath: 'assets/icons/google.png',
                  onTap: () {
                    context.read<AuthBloc>().add(GoogleLoginSubmitted());
                  },
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DriverRegisterPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Cần một tài khoản thực thể? ",
                          style: TextStyle(color: Colors.black87),
                        ),
                        TextSpan(
                          text: "Đăng ký",
                          style: TextStyle(
                            color: Color(0xFF2A5EE1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                const Center(
                  child: Text.rich(
                    TextSpan(
                      text: "From ",
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "DHAY",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}