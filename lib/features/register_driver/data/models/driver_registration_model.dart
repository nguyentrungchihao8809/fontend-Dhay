import '../../domain/entities/driver_registration.dart';

class DriverRegistrationModel extends DriverRegistration {
  const DriverRegistrationModel({
    required super.licenseNumber,
    required super.vehiclePlate,
    required super.vehicleBrand,
    required super.capacity,
    required super.vehicleType,
    required super.vehicleModel,
  });

  // Chuyển từ Entity sang Model để xử lý ở tầng Data
  factory DriverRegistrationModel.fromEntity(DriverRegistration entity) {
    return DriverRegistrationModel(
      licenseNumber: entity.licenseNumber,
      vehiclePlate: entity.vehiclePlate,
      vehicleBrand: entity.vehicleBrand,
      capacity: entity.capacity,
      vehicleType: entity.vehicleType,
      vehicleModel: entity.vehicleModel,
    );
  }

  // Chuyển Model thành JSON để gửi lên Backend (PostMapping)
  Map<String, dynamic> toJson() {
    return {
      'licenseNumber': licenseNumber,
      'vehiclePlate': vehiclePlate,
      'vehicleBrand': vehicleBrand,
      'capacity': capacity,
      'vehicleType': vehicleType,
      'vehicleModel': vehicleModel,
    };
  }

  // Nhận dữ liệu từ JSON (nếu cần)
  factory DriverRegistrationModel.fromJson(Map<String, dynamic> json) {
    return DriverRegistrationModel(
      licenseNumber: json['licenseNumber'] ?? '',
      vehiclePlate: json['vehiclePlate'] ?? '',
      vehicleBrand: json['vehicleBrand'] ?? '',
      capacity: json['capacity'] ?? 0,
      vehicleType: json['vehicleType'] ?? '',
      vehicleModel: json['vehicleModel'] ?? '',
    );
  }
}