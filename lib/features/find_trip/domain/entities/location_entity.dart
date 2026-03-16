import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final double distance;
  final double? latitude;
  final double? longitude;

  const LocationEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [id, name, address, distance, latitude, longitude];
}