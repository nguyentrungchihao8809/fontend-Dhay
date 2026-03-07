abstract class RegisterDriverEvent {}

class RegisterDriverSubmitted extends RegisterDriverEvent {
  final String licenseNumber;
  final String vehiclePlate;
  final String vehicleBrand;
  final String vehicleModel;
  final int capacity;
  final String vehicleType;

  RegisterDriverSubmitted({
    required this.licenseNumber,
    required this.vehiclePlate,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.capacity,
    required this.vehicleType,
  });
}