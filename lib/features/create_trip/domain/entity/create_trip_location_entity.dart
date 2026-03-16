// lib/domain/entity/create_trip_location_entity.dart

class CreateTripLocationEntity {
  final String name;
  final String address;
  final double latitude;  // Tọa độ vĩ độ
  final double longitude; // Tọa độ kinh độ

  CreateTripLocationEntity({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}