class TripRouteEntity {
  final String startLocation;
  final String endLocation;
  final List<String> waypoints; // Đổi từ intermediates thành waypoints
  final double rating;

  TripRouteEntity({
    required this.startLocation,
    required this.endLocation,
    required this.waypoints,
    required this.rating,
  });
}