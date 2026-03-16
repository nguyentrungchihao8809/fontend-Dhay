class SavedTripEntity {
  final String name;           // Tên gợi nhớ (Vd: Đi chơi, Về nhà)
  final String startLocation;   // Điểm đi
  final String endLocation;     // Điểm đến
  final String tag;            // Nhà, Công ty, Khác...

  SavedTripEntity({
    required this.name,
    required this.startLocation,
    required this.endLocation,
    required this.tag,
  });
}