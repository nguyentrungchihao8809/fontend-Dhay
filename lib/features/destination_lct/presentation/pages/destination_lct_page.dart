import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/destination_bloc.dart'; // Đã đổi sang DestinationBloc

class DestinationLctPage extends StatelessWidget {
  const DestinationLctPage({super.key});

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

          // 2. Nút Quay lại - Đồng nhất với Find Trip
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. Thanh tìm kiếm - Đổi thành "Điểm đến"
          Positioned(
            top: 130,
            left: 30,
            right: 30,
            child: CustomTextField(
              hintText: "Điểm đến...", // ĐÃ ĐỔI
              prefixIcon: _buildMapDot(),
              suffixIcon: const Icon(Icons.my_location, color: Colors.black, size: 22),
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

  Widget _buildBottomPanel() {
    return Container(
      height: 411,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFD9D8D8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: BlocBuilder<DestinationBloc, DestinationState>( // ĐÃ ĐỔI SANG DESTINATION
        builder: (context, state) {
          String name = "Đang định vị...";
          String addr = "Vui lòng đợi giây lát...";

          if (state is DestinationLoaded) { // ĐÃ ĐỔI STATE
            name = state.name;
            addr = state.address;
          }
          if (state is DestinationError) { // ĐÃ ĐỔI STATE
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
              _labelText("Điểm đến:"), // ĐÃ ĐỔI
              _infoCard(name, addr, 79),
              const SizedBox(height: 20),
              _labelText("Ghi chú:"),
              _infoCard("Nhập ghi chú cho điểm đến...", "", 45, isHint: true), // ĐÃ ĐỔI
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
        child: Text(
            "Xác nhận điểm đến", // ĐÃ ĐỔI
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)
        ),
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