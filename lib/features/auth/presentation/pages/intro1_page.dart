import 'package:flutter/material.dart';

class Intro1Page extends StatefulWidget {
  const Intro1Page({super.key});

  @override
  State<Intro1Page> createState() => _Intro1PageState();
}

class _Intro1PageState extends State<Intro1Page> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Dữ liệu nội dung và ảnh tương ứng cho 3 trang
  final List<Map<String, String>> _onboardingData = [
    {
      "text": "“Có chúng tôi đồng hành, mọi hành trình trở nên nhẹ nhàng hơn, tiết kiệm hơn và tràn đầy những kết nối thú vị.”",
      "image": "assets/images/intro_1.png",
    },
    {
      "text": "“Đồng hành cùng sự an tâm – tài xế đã xác minh, chuyến đi an toàn và độ tin cậy bạn có thể đặt trọn niềm tin.”",
      "image": "assets/images/intro_2.png",
    },
    {
      "text": "“Theo dõi chuyến đi của bạn theo thời gian thực, luôn nắm rõ vị trí, lộ trình và điểm đến để mỗi hành trình đều minh bạch và an tâm.”",
      "image": "assets/images/intro_3.png",
    },
  ];

  void _onNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Pattern tĩnh (Toàn màn hình)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_pattern.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Hình ảnh minh họa (Vị trí cố định như cũ)
          // Sử dụng AnimatedSwitcher để tạo hiệu ứng chuyển ảnh nhẹ nhàng khi đổi trang
          Positioned(
            top: 115,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Image.asset(
                _onboardingData[_currentPage]["image"]!,
                key: ValueKey<int>(_currentPage), // Quan trọng để AnimatedSwitcher nhận biết thay đổi
                height: 362,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 3. PageView cho phần Text và Card (Phần trượt)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 80, left: 29, right: 29),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  height: 328,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Indicator nằm trong card
                      _buildIndicatorRow(),
                      const SizedBox(height: 25),
                      const Text(
                        "Welcome to DHAY!",
                        style: TextStyle(
                          fontFamily: 'Righteous',
                          fontSize: 26,
                          color: Color(0xFF395BFC),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _onboardingData[index]["text"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 4. Nút bấm hình tròn (Cố định)
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _onNextPage,
                child: _buildGradientButton(),
              ),
            ),
          ),

          // 5. Footer Text
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              "From DHAY",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingData.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 10,
          width: index == _currentPage ? 35 : 11,
          decoration: BoxDecoration(
            color: index == _currentPage ? const Color(0xFF395BFC) : const Color(0xFF9F9696),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton() {
    return Container(
      width: 86,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF759CC3), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F8F8), Color(0xFF0059FF)],
        ),
      ),
      child: const Icon(Icons.arrow_forward, color: Colors.black, size: 35),
    );
  }
}