import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_trip_bloc.dart';
import '../widgets/location_input_field.dart';
import '../widgets/recent_destination_item.dart';

class CreateTripPage extends StatelessWidget {
  const CreateTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER TITLE ---
            const Padding(
              padding: EdgeInsets.only(top: 21, bottom: 10),
              child: Center(
                child: Text(
                  "Tạo chuyến đi",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFF9F9F9),
              thickness: 2,
              indent: 27,
              endIndent: 27,
            ),

            // --- CHIPS SELECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              child: Row(
                children: [
                  _buildChip(Icons.calendar_month, "Lịch Hẹn"),
                  const SizedBox(width: 26),
                  _buildChip(Icons.star, "Đã lưu"),
                ],
              ),
            ),

            // --- SEARCH BOX (THE CORE) ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: LocationInputField(), // Widget này đã chứa logic Bloc.add(SearchQueryChanged)
            ),

            // --- DYNAMIC CONTENT (SEARCH RESULTS OR RECENT) ---
            Expanded(
              child: BlocBuilder<CreateTripBloc, CreateTripState>(
                builder: (context, state) {
                  // 1. Trường hợp đang tải dữ liệu từ Mapbox
                  if (state is CreateTripLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }

                  // 2. Trường hợp đã có kết quả Search (Hiển thị list gợi ý địa chỉ)
                  if (state is CreateTripLoaded) {
                    final results = state.lastModifiedField == LocationFieldType.pickup
                        ? state.pickupResults
                        : state.dropoffResults;

                    // Nếu kết quả rỗng thì quay lại hiện "Gần đây"
                    if (results.isEmpty) return _buildRecentSection();

                    return ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: results.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final location = results[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                          title: Text(
                            location.name,
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                          ),
                          subtitle: Text(
                            location.address,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                                  context.read<CreateTripBloc>().add(
                                      SelectLocationEvent(
                                          location, state.lastModifiedField)
                                  );
                                  FocusScope
                                      .of(context)
                                      .unfocus(); // Tắt bàn phím
                            debugPrint("User chọn: ${location.name}");
                          },
                        );
                      },
                    );
                  }

                  // 3. Trường hợp lỗi
                  if (state is CreateTripError) {
                    return Center(child: Text(state.message));
                  }

                  // 4. Mặc định hiện danh sách "Gần đây" (Trạng thái Initial)
                  return _buildRecentSection();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị danh sách "Gần đây" theo thiết kế Figma
  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, top: 25, bottom: 10),
          child: Text(
            "Gần đây",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            children: const [
              RecentDestinationItem(
                startLocation: "Công viên Gia Định . Quận Gò Vấp . Tp.HCM",
                endLocation: "Nhà Thờ Đức Bà . Quận 1 . Tp.HCM",
                distance: "7 km",
                duration: "15 - 20 phút",
              ),
              SizedBox(height: 20),
              RecentDestinationItem(
                startLocation: "Nhà Thờ Đức Bà . Quận 1 . Tp.HCM",
                endLocation: "Khu đô thị Phú Mỹ Hưng . Quận 7 . Tp.HCM",
                distance: "7 km",
                duration: "20 - 30 phút",
              ),
            ],
          ),
        ),
      ],
    );
  }

  // UI Chip (Lịch hẹn/Đã lưu)
  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4FA),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }
}