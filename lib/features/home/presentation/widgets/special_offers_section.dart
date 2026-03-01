import 'package:flutter/material.dart';

class SpecialOffersSection extends StatelessWidget {
  const SpecialOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chỉnh khoảng cách tiêu đề đồng bộ với các section khác
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text("Ưu đãi đặc biệt",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        ),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            children: [
              // Đảm bảo đường dẫn này chính xác tuyệt đối với thư mục assets của bạn
              _buildOfferCard('assets/images/img_offer_time_deal.png'),
              _buildOfferCard('assets/images/img_offer_time_deal.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(String imagePath) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Nếu ảnh lỗi, box màu xám sẽ hiện lên để bạn biết
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            print("Lỗi không tìm thấy ảnh: $imagePath"); // In ra lỗi nếu sai đường dẫn
          },
        ),
      ),
    );
  }
}