import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterDriverPage extends StatefulWidget {
  const RegisterDriverPage({super.key});

  @override
  State<RegisterDriverPage> createState() => _RegisterDriverPageState();
}

class _RegisterDriverPageState extends State<RegisterDriverPage> {
  // Controllers cho các trường nhập liệu
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Kích thước chuẩn từ CSS (412x917)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 412;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 917 * scale,
          width: screenWidth,
          child: Stack(
            children: [
              // 1. ChatGPT Image (Background top left)
              Positioned(
                left: -45 * scale,
                top: 0,
                child: Image.network(
                  'https://via.placeholder.com/196x91', // Thay bằng asset của bạn
                  width: 196 * scale,
                  height: 91 * scale,
                ),
              ),

              // 2. Tiêu đề: Đăng ký trở thành Driver
              Positioned(
                left: 53 * scale,
                top: 91 * scale,
                child: _buildText("Đăng ký trở thành Driver", 24, FontWeight.w800,
                    width: 317 * scale, height: 65 * scale),
              ),

              // 3. Ellipse 64 (Ảnh đại diện/Logo tròn)
              Positioned(
                left: 137 * scale,
                top: 171 * scale,
                child: Container(
                  width: 134 * scale,
                  height: 126 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    boxShadow: const [
                      BoxShadow(color: Color(0x40000000), offset: Offset(5, 5), blurRadius: 4),
                    ],
                  ),
                ),
              ),

              // 4. Rectangle 517 (Thẻ nền chính cho Form)
              Positioned(
                left: 32 * scale,
                top: 238 * scale,
                child: Container(
                  width: 344 * scale,
                  height: 593 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEFCFF),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFFD9D9D9), blurRadius: 10, spreadRadius: 4, offset: Offset(0, 4)),
                    ],
                  ),
                ),
              ),

              // 5. Rectangle 170 (Khung thông báo chào mừng)
              Positioned(
                left: 53 * scale,
                top: 313 * scale,
                child: Container(
                  width: 305 * scale,
                  height: 162 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black),
                    boxShadow: const [
                      BoxShadow(color: Color(0x40000000), offset: Offset(0, 4), blurRadius: 4),
                    ],
                  ),
                ),
              ),

              // 6. Nội dung text trong khung chào mừng
              Positioned(
                left: 64 * scale,
                top: 322 * scale,
                child: _buildText("Chào mừng bạn đến với DHAY với vai trò tài xế", 16,
                    FontWeight.w500, width: 280 * scale, height: 40 * scale, textAlign: TextAlign.center),
              ),
              Positioned(
                left: 68 * scale,
                top: 394 * scale,
                child: _buildText(
                    "Vui lòng đảm bảo thông tin phương tiện chính xác, tuân thủ luật giao thông...",
                    14, FontWeight.w300, width: 292 * scale, height: 40 * scale),
              ),

              // 7. CÁC TRƯỜNG NHẬP LIỆU (Input Fields)
              _buildInputField(scale, "Số bằng lái", 488, _licenseController),
              _buildInputField(scale, "Biển số xe", 527, _plateController),
              _buildInputField(scale, "Hãng xe", 567, _brandController),
              _buildInputField(scale, "Loại xe", 607, _typeController),
              _buildInputField(scale, "Dòng xe", 647, _modelController),
              _buildInputField(scale, "Số ghế trống", 686, _seatsController),

              // 8. Nút Đăng ký (Rounded rectangle)
              Positioned(
                left: 84 * scale,
                top: 765 * scale,
                child: InkWell(
                  onTap: () => print("Đăng ký click"),
                  child: Container(
                    width: 243 * scale,
                    height: 45 * scale,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Color(0x40000000), offset: Offset(0, 8), blurRadius: 4),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Đăng ký",
                      style: GoogleFonts.poppins(
                        fontSize: 19 * scale,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // 9. From DHAY (Footer)
              Positioned(
                left: 163 * scale,
                top: 851 * scale,
                child: _buildText("From DHAY", 16, FontWeight.w500, width: 120 * scale, height: 52 * scale),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con để build Text chuẩn CSS
  Widget _buildText(String text, double size, FontWeight weight,
      {double? width, double? height, TextAlign textAlign = TextAlign.left}) {
    return SizedBox(
      width: width,
      height: height,
      child: Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.poppins(
          fontSize: size,
          fontWeight: weight,
          color: Colors.black,
          letterSpacing: 0.01,
        ),
      ),
    );
  }

  // Widget con để build các Input Field kèm Line bên dưới
  Widget _buildInputField(double scale, String hint, double top, TextEditingController controller) {
    return Stack(
      children: [
        Positioned(
          left: 60 * scale,
          top: top * scale,
          child: SizedBox(
            width: 292 * scale,
            height: 40 * scale,
            child: TextField(
              controller: controller,
              style: GoogleFonts.poppins(fontSize: 15 * scale, fontWeight: FontWeight.w300),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        // Line bên dưới TextField (CSS Line 13-19)
        Positioned(
          left: 59 * scale,
          top: (top + 38) * scale,
          child: Container(
            width: 293 * scale,
            height: 1,
            color: Colors.black.withOpacity(0.42),
          ),
        ),
        // Icon bên phải (CSS image 138-141)
        Positioned(
          left: 327 * scale,
          top: (top + 4) * scale,
          child: Container(
            width: 23 * scale,
            height: 23 * scale,
            decoration: const BoxDecoration(
              color: Colors.grey, // Thay bằng Image.asset
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}