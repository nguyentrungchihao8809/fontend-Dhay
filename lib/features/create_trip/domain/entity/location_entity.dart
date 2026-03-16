enum LocationFieldType { pickup, dropoff }

class LocationModel {
  final String name;
  final String address;
  final double lat;
  final double lng;

  LocationModel({required this.name, required this.address, required this.lat, required this.lng});
}