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
    // Mapbox trả về tọa độ trong [longitude, latitude]
    final List<dynamic> coordinates = json['geometry']?['coordinates'] ?? [0.0, 0.0];

    return CreateTripLocationModel(
      // 'text' thường là tên địa điểm ngắn gọn (VD: Bitexco)
      name: json['text'] ?? '',
      // 'place_name' là địa chỉ đầy đủ (VD: 2 Hải Triều, Bến Nghé, Quận 1...)
      address: json['place_name'] ?? '',
      longitude: (coordinates[0] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
    );
  }
}