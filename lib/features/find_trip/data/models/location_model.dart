import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.id,
    required super.name,
    required super.address,
    required super.distance,
    super.latitude,
    super.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      name: json['text'] ?? json['name'] ?? '',
      address: json['place_name'] ?? json['address'] ?? '',
      // Mapbox returns distance in meters, or custom API might differ
      distance: (json['distance'] ?? 0.0) / 1000.0,
      latitude: json['center'] != null ? json['center'][1] : json['lat'],
      longitude: json['center'] != null ? json['center'][0] : json['lng'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'lat': latitude,
      'lng': longitude,
    };
  }
}