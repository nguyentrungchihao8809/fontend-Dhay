import 'package:equatable/equatable.dart';

class DriverRegistration extends Equatable {
  final String licenseNumber;
  final String vehiclePlate;
  final String vehicleBrand;
  final int capacity;
  final String vehicleType;
  final String vehicleModel;

  const DriverRegistration({
    required this.licenseNumber,
    required this.vehiclePlate,
    required this.vehicleBrand,
    required this.capacity,
    required this.vehicleType,
    required this.vehicleModel,
  });

  @override
  List<Object?> get props => [
    licenseNumber,
    vehiclePlate,
    vehicleBrand,
    capacity,
    vehicleType,
    vehicleModel,
  ];
}