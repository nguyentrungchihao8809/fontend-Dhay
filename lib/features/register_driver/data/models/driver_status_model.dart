import '../../domain/entities/driver_status.dart';

class DriverStatusModel extends DriverStatus {
  const DriverStatusModel({required super.isRegistered, required super.message});

  factory DriverStatusModel.fromJson(Map<String, dynamic> json) {
    return DriverStatusModel(
      isRegistered: json['isRegistered'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRegistered': isRegistered,
      'message': message,
    };
  }
}