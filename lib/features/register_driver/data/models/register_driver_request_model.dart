class RegisterDriverRequestModel {
  final String licenseNumber;
  final String vehiclePlate;
  final String vehicleBrand;
  final String vehicleModel; // Fix lỗi undefined
  final int capacity;
  final String vehicleType;

  RegisterDriverRequestModel({
    required this.licenseNumber,
    required this.vehiclePlate,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.capacity,
    required this.vehicleType,
  });

  Map<String, dynamic> toJson() {
    return {
      'licenseNumber': licenseNumber,
      'vehiclePlate': vehiclePlate,
      'vehicleBrand': vehicleBrand,
      'vehicleModel': vehicleModel,
      'capacity': capacity,
      'vehicleType': vehicleType,
    };
  }
}