import 'package:flutter/material.dart';
import '../../domain/entity/trip_route_entity.dart';

class RouteSuggestionItem extends StatelessWidget {
  final TripRouteEntity route;

  const RouteSuggestionItem({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    // Kết hợp tất cả các điểm thành một danh sách để vẽ: [Điểm đi, ...Trung gian, Điểm đến]
    // Lưu ý: Tùy vào Entity của cưng đặt tên là waypoints hay intermediates mà đổi tên cho khớp nhé
    List<String> allPoints = [
      route.startLocation,
      ...route.waypoints, // Hoặc route.intermediates nếu cưng đổi tên biến
      route.endLocation
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CỘT TRỤC ĐƯỜNG (HÌNH XƯƠNG CÁ DỌC) ---
          Column(
            children: List.generate(allPoints.length, (index) {
              bool isFirst = index == 0;
              bool isLast = index == allPoints.length - 1;

              return Column(
                children: [
                  // Vẽ Icon hoặc Chấm tròn
                  if (isFirst)
                    const Icon(Icons.radio_button_checked, size: 16, color: Colors.black)
                  else if (isLast)
                    const Icon(Icons.location_on, size: 16, color: Colors.black)
                  else
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                    ),

                  // Vẽ đường nối (không vẽ ở điểm cuối cùng)
                  if (!isLast)
                    Container(
                      width: 1.5,
                      height: 30, // Độ dài đoạn nối giữa các điểm
                      color: Colors.black,
                    ),
                ],
              );
            }),
          ),
          const SizedBox(width: 15),

          // --- CỘT THÔNG TIN ĐỊA CHỈ (CĂN CHỈNH KHỚP VỚI TRỤC) ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(allPoints.length, (index) {
                bool isMain = index == 0 || index == allPoints.length - 1;

                return Container(
                  height: index == allPoints.length - 1 ? 20 : 46, // Chiều cao phải khớp với trục đường ở trên
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          allPoints[index],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: isMain ? 13 : 10,
                            fontWeight: isMain ? FontWeight.w600 : FontWeight.w400,
                            color: isMain ? Colors.black : const Color(0xFFB9B9B9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Hiển thị Rating ở dòng đầu tiên
                      if (index == 0)
                        Row(
                          children: [
                            Text(
                              route.rating.toString(),
                              style: const TextStyle(fontSize: 10, color: Color(0xFF959595)),
                            ),
                            const Icon(Icons.star, color: Color(0xFFFFBF00), size: 14),
                          ],
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}