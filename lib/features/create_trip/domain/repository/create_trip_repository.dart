// lib/features/create_trip/domain/repository/create_trip_repository.dart
import '../entity/create_trip_location_entity.dart';
import '../../data/entity/create_trip_location_entity.dart';

abstract class CreateTripRepository {
  /// Tìm kiếm danh sách địa điểm từ từ khóa (query)
  Future<List<CreateTripLocationEntity>> searchLocations(String query);

// Sau này có thể thêm:
// Future<void> saveTrip(TripEntity trip);
}