import '../../../../core/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.fullName,
    required super.email,
    required super.avatarUrl,
    required super.phoneNumber,
    super.gender,
    super.vehicleType,
    super.vehicleBrand,
    super.plateNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'] ?? 'Người dùng DHAY',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      phoneNumber: json['identifier'] ?? '',
      gender: json['gender'] ?? 'Nữ',
      vehicleType: json['vehicleType'] ?? 'Xe máy',
      vehicleBrand: json['vehicleBrand'] ?? 'Vision',
      plateNumber: json['plateNumber'] ?? '66H-1234',
    );
  }
}