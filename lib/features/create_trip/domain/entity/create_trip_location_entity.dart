// lib/features/create_trip/domain/entity/create_trip_location_entity.dart
class CreateTripLocationEntity {
  final String name;
  final String address; // Thêm dòng này
  final double latitude;
  final double longitude;

  CreateTripLocationEntity({
    required this.name,
    required this.address, // Thêm dòng này
    required this.latitude,
    required this.longitude,
  });
}