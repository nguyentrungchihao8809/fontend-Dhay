import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ghepxenew/core/theme/app_colors.dart';
import 'package:ghepxenew/features/home_driver/presentation/widgets/driver_bottom_nav.dart';

class HomeDriverPage extends StatelessWidget {
  const HomeDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).size.width / 428;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(scaleFactor),
                  const SizedBox(height: 25),
                  _buildSearchBar(scaleFactor),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Sắp tới"),
                  _buildUpcomingCard(scaleFactor),

                  const SizedBox(height: 30),
                  _buildSectionTitle("Chuyến đang diễn ra"),
                  _buildCurrentTripCard(scaleFactor),

                  const SizedBox(height: 30),
                  _buildSectionTitle("Chuyến đã lưu"),

                  // 📍 TRUYỀN THÊM THÔNG SỐ KM VÀO ĐÂY NÈ CƯNG
                  _buildSavedTripCard(
                      "Công viên Gia Định . Quận Gò Vấp",
                      "Nhà Thờ Đức Bà . Quận 1",
                      "7 km",
                      "15 - 20 phút"
                  ),
                  _buildSavedTripCard(
                      "Nhà Thờ Đức Bà . Quận 1",
                      "Phú Mỹ Hưng . Quận 7",
                      "12 km",
                      "20 - 30 phút"
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: DriverBottomNav(),
            ),
          ],
        ),
      ),
    );
  }

  // 📝 Tiêu đề (Canh giữa)
  Widget _buildHeader(double scale) {
    return Center(
      child: Text(
        "Tạo chuyến đi",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 30 * scale,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  // 🔍 Thanh tìm kiếm
  Widget _buildSearchBar(double scale) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    "Bạn muốn đi đâu...",
                    style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 15 * scale),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_month, color: Colors.white, size: 30),
                  const SizedBox(width: 5),
                  Text(
                    "Tạo hẹn",
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15 * scale),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 📅 Card Sắp tới - Đã thêm bộ điều khiển Box đen và Icon lịch
  Widget _buildUpcomingCard(double scale) {
    return Container(
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bạn có hai chuyến\nhoạt động sắp diễn ra",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text("Xem chi tiết", style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                      const SizedBox(width: 6),
                      // Anh chỉnh lại cái mũi tên tí cho nó căn giữa đẹp hơn nhé
                      Text(
                        "→",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textGrey, height: -0.3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🎯 1. LỚP ĐIỀU KHIỂN BOX ĐEN (Dùng để dịch chuyển nguyên cái hộp màu đen)
          Padding(
            padding: const EdgeInsets.only(
              right: 10,  // 👈 Tăng số này để đẩy nguyên Box đen sang TRÁI
              left: 0,   // 👈 Tăng số này để đẩy nguyên Box đen sang PHẢI
              top: 0,    // 👈 Tăng số này để đẩy nguyên Box đen xuống DƯỚI
              bottom: 0, // 👈 Tăng số này để đẩy nguyên Box đen lên TRÊN
            ),
            child: Container(
              width: 85 * scale,
              height: 85,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)
                ),
              ),
              // 🎯 2. CHỖ ĐIỀU CHỈNH VỊ TRÍ ICON LỊCH (Chỉ dịch chuyển cái hình lịch bên trong box đen)
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 0,   // Dịch lịch sang phải
                    right: 0,  // Dịch lịch sang trái
                    top: 0,    // Dịch lịch xuống dưới
                    bottom: 0, // Dịch lịch lên trên
                  ),
                  child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                      size: 50
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 🗺️ Card Chuyến đi hiện tại
  Widget _buildCurrentTripCard(double scale) {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.blue[50],
            child: Center(child: Icon(Icons.map, size: 50, color: Colors.blue[200])),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    _timelineNode(true, size: 20),
                    Expanded(child: Container(height: 2, color: Colors.black)),
                    _timelineNode(false, size: 20),
                    Expanded(child: Container(height: 2, color: Colors.black)),
                    const Icon(Icons.location_on, color: Colors.black, size: 30),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("12 phút | 4.3km", style: GoogleFonts.poppins(fontSize: 12)),
                    Text("Tổng: 8.300 VNĐ", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 📍 Card Chuyến đã lưu - Đã fix lỗi xuống dòng và căn chỉnh chữ ngay hàng
  Widget _buildSavedTripCard(String start, String end, String distance, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🛤️ Cột lộ trình (Chấm đen & Icon định vị)
          Column(
            children: [
              const SizedBox(height: 4), // Đẩy chấm đen xuống tí cho ngay dòng chữ đầu
              _timelineNode(true, size: 16),
              // 🎯 ĐÂY LÀ ĐOẠN ĐIỀU CHỈNH ĐƯỜNG KẺ
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,    // 👈 Tăng số này để đẩy đầu trên của đường kẻ xuống thấp (rời xa chấm đen)
                  bottom: 0, // 👈 Tăng số này để đẩy đầu dưới của đường kẻ lên cao (rời xa icon định vị)
                ),
                child: Container(
                  width: 3, // Để 1 hoặc 2 cho thanh mảnh giống hình mẫu nhé cưng, 3 hơi dày
                  height: 24, // 👈 Tăng số này nếu muốn địa chỉ 1 và địa chỉ 2 cách xa nhau hơn
                  color: AppColors.divider,
                ),
              ),
              const Icon(Icons.location_on, size: 25),
            ],
          ),
          const SizedBox(width: 15),

          // 🏠 Phần địa chỉ - Đã căn chỉnh lại khoảng cách để ngang hàng với icon
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chỉnh height này để dòng 1 khớp tâm chấm đen
                const SizedBox(height: 2),
                Text(
                    start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)
                ),

                // 🎯 Tăng khoảng cách này để đẩy dòng 2 xuống đúng vị trí Icon định vị
                // Nếu cưng thấy chưa khớp, cứ tăng/giảm số 22 này một chút là được
                const SizedBox(height: 30),

                Text(
                    end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)
                ),
              ],
            ),
          ),
          // 🏁 Cột bên phải: Đã chỉnh màu xám và hạ thấp xuống
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 35), // 👈 Cưng tăng/giảm số này để đẩy vị trí chữ xuống thấp hay cao nhé
              Text(
                distance,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400, // Bỏ in đậm
                  color: AppColors.textGrey,    // Chữ màu xám
                ),
              ),
              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textGrey,    // Chữ màu xám
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ⭕ HÀM VẼ CHẤM TRÒN
  Widget _timelineNode(bool filled, {double size = 16}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? Colors.black : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 5), // Anh chỉnh lại width=2 cho thanh mảnh nhé
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}