import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.name,
    required super.address,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }

  // Bạn có thể thêm hàm toJson nếu sau này cần gửi dữ liệu lên Server
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
    };
  }
}