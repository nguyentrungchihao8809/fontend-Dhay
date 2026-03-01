import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool _isTimerDone = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      _isTimerDone = true;
    });
    // Sau khi hết 3s, kiểm tra state hiện tại của Bloc để điều hướng ngay
    _checkAndNavigate(context.read<AuthBloc>().state);
  }

  void _checkAndNavigate(AuthState state) {
    // CHỈ điều hướng khi cả 2 điều kiện này thỏa mãn:
    if (!_isTimerDone) return;

    if (state is AuthSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (state is AuthFailure || state is AuthInitial) {
      // AuthInitial ở đây nghĩa là AppStarted đã chạy xong và xác nhận không có token
      Navigator.pushReplacementNamed(context, '/intro1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // KHÔNG gọi SharedPreferences ở đây nữa!
            // Bloc đã làm việc đó rồi.

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Chào mừng ${state.user.fullName}!")),
              );

              // Điều hướng thẳng về Home
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red
              ),
            );
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Image.asset(
                    'assets/images/logo_intro.jpg',
                    width: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(text: "From "),
                        TextSpan(
                          text: "DHAY",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A64FE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}