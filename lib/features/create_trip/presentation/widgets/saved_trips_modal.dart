import 'package:flutter/material.dart';
import '../../domain/entity/saved_trip_entity.dart';

class SavedTripsModal extends StatelessWidget {
  final List<SavedTripEntity> trips;

  const SavedTripsModal({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        width: double.infinity,
        // Giới hạn chiều cao tối đa để không bị tràn màn hình nếu danh sách quá dài
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Header: Icon Close và Tiêu đề ---
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Text(
                  "Chuyến Đã Lưu",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),

            // --- Danh sách các chuyến đã lưu ---
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return _buildSavedTripItem(trip);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget vẽ từng Item theo style Ảnh 2/3 ---
  Widget _buildSavedTripItem(SavedTripEntity trip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tên gợi nhớ + Icon Bookmark đen
          Row(
            children: [
              const Icon(Icons.bookmark, size: 20, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                trip.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2. Box trắng bao quanh địa chỉ (Rectangle style)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: const Color(0xFFF0F0F0)), // Viền nhẹ cho sang
            ),
            child: Row(
              children: [
                // Cột Icon lộ trình
                Column(
                  children: [
                    const Icon(Icons.radio_button_checked, size: 14, color: Colors.black),
                    Container(width: 1.5, height: 20, color: Colors.grey[400]),
                    const Icon(Icons.location_on, size: 14, color: Colors.black),
                  ],
                ),
                const SizedBox(width: 12),
                // Cột Text địa chỉ
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.startLocation,
                        style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        trip.endLocation,
                        style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}