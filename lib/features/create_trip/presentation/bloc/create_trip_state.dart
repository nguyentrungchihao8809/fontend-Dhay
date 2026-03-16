import '../../domain/entity/trip_route_entity.dart';
import '../../domain/entity/location_entity.dart';

abstract class CreateTripState {}

class CreateTripInitial extends CreateTripState {}

class CreateTripLoading extends CreateTripState {}

class CreateTripError extends CreateTripState {
  final String message;
  CreateTripError(this.message);
}

class CreateTripLoaded extends CreateTripState {
  // Anh dùng dynamic ở đây để chắc chắn cưng không bị lỗi
  // nếu file location_entity đặt tên class khác nhau
  final List<dynamic> pickupResults;
  final List<dynamic> dropoffResults;
  final dynamic selectedPickup;
  final dynamic selectedDropoff;
  final List<dynamic> savedTrips;
  final LocationFieldType lastModifiedField;

  // Đây là biến quan trọng để hiện cái "Xương cá"
  final List<TripRouteEntity> routeSuggestions;

  CreateTripLoaded({
    this.pickupResults = const [],
    this.dropoffResults = const [],
    this.selectedPickup,
    this.selectedDropoff,
    this.savedTrips = const [],
    this.lastModifiedField = LocationFieldType.pickup,
    this.routeSuggestions = const [], // Khởi tạo mảng rỗng để không bị null
  });

  CreateTripLoaded copyWith({
    List<dynamic>? pickupResults,
    List<dynamic>? dropoffResults,
    dynamic selectedPickup,
    dynamic selectedDropoff,
    List<dynamic>? savedTrips,
    LocationFieldType? lastModifiedField,
    List<TripRouteEntity>? routeSuggestions,
  }) {
    return CreateTripLoaded(
      pickupResults: pickupResults ?? this.pickupResults,
      dropoffResults: dropoffResults ?? this.dropoffResults,
      selectedPickup: selectedPickup ?? this.selectedPickup,
      selectedDropoff: selectedDropoff ?? this.selectedDropoff,
      savedTrips: savedTrips ?? this.savedTrips,
      lastModifiedField: lastModifiedField ?? this.lastModifiedField,
      routeSuggestions: routeSuggestions ?? this.routeSuggestions,
    );
  }
}