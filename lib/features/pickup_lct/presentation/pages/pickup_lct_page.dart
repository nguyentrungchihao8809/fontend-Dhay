import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/pickup_bloc.dart';

class PickupLctPage extends StatelessWidget {
  const PickupLctPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Bản đồ giả lập (Background)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE0E0E0),
            child: const Center(
                child: Icon(Icons.map, size: 80, color: Colors.grey)
            ),
          ),

          // 2. SỬA TẠI ĐÂY: Nút Quay lại khớp với Find Trip
          Positioned(
            top: 50, // Khớp tọa độ trang Find Trip
            left: 20, // Khớp tọa độ trang Find Trip
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20, // Độ lớn hình tròn trắng
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. Thanh tìm kiếm (Giữ nguyên hoặc chỉnh top cho cân đối)
          Positioned(
            top: 130, // Chỉnh lại một chút để không đè lên nút quay lại
            left: 30,
            right: 30,
            child: CustomTextField(
              hintText: "Điểm đón...",
              prefixIcon: _buildMapDot(),
            ),
          ),

          // 4. Panel Thông tin phía dưới
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomPanel(),
          ),
        ],
      ),
    );
  }

  // --- Các hàm bên dưới giữ nguyên như cũ của bạn ---
  Widget _buildBottomPanel() {
    return Container(
      height: 411,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFBDBDBD),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: BlocBuilder<PickupBloc, PickupState>(
        builder: (context, state) {
          String name = "Đang định vị...";
          String addr = "Vui lòng đợi giây lát...";

          if (state is PickupLoaded) {
            name = state.name;
            addr = state.address;
          }
          if (state is PickupError) {
            name = "Lỗi kết nối";
            addr = state.message;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 60, height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 33),
              _labelText("Điểm đón:"),
              _infoCard(name, addr, 79),
              const SizedBox(height: 20),
              _labelText("Ghi chú:"),
              _infoCard("Nhập ghi chú...", "", 45, isHint: true),
              const SizedBox(height: 40),
              _buildConfirmButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _labelText(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)
    ),
  );

  Widget _infoCard(String t1, String t2, double h, {bool isHint = false}) {
    return Container(
      height: h, width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2F2),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t1, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: isHint ? Colors.black38 : Colors.black)),
          if (t2.isNotEmpty)
            Text(t2, style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF3B3939)), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() => Center(
    child: Container(
      width: 243, height: 45,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 8), blurRadius: 4)],
      ),
      child: Center(
        child: Text("Xác nhận điểm đón", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
      ),
    ),
  );

  Widget _buildMapDot() => Container(
    width: 20, height: 20,
    decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
    child: Center(
      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
    ),
  );
}