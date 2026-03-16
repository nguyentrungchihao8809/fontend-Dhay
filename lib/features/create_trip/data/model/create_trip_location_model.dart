// lib/features/create_trip/data/model/create_trip_location_model.dart
import '../../domain/entity/create_trip_location_entity.dart';

class CreateTripLocationModel extends CreateTripLocationEntity {
  CreateTripLocationModel({
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
  });

  factory CreateTripLocationModel.fromJson(Map<String, dynamic> json) {
    // Mapbox trả về tọa độ theo định dạng mảng: [longitude, latitude]
    // Sử dụng toán tử null-safety (?.) và giá trị mặc định để tránh lỗi crash code
    final List<dynamic> coordinates = json['geometry']?['coordinates'] ?? [0.0, 0.0];

    return CreateTripLocationModel(
      // 'text' là tên địa điểm (ví dụ: Landmark 81)
      name: json['text'] ?? '',

      // 'place_name' là địa chỉ chi tiết đầy đủ
      address: json['place_name'] ?? '',

      // Mapbox: index 0 là Kinh độ (Longitude), index 1 là Vĩ độ (Latitude)
      longitude: (coordinates[0] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
    );
  }

  // Nếu bạn cần gửi dữ liệu ngược lại server sau này
  Map<String, dynamic> toJson() {
    return {
      'text': name,
      'place_name': address,
      'geometry': {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      },
    };
  }
}