import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String fullName;
  final String email;
  final String avatarUrl;
  final String phoneNumber;
  final String gender;
  final String vehicleType;
  final String vehicleBrand;
  final String plateNumber;
  final String language;
  final double rating;

  const ProfileEntity({
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.phoneNumber,
    this.gender = "Nữ",
    this.vehicleType = "Xe máy",
    this.vehicleBrand = "Vision",
    this.plateNumber = "66H-1234",
    this.language = "Tiếng Việt",
    this.rating = 3.1,
  });

  /// Senior Tip: Sử dụng copyWith để cập nhật từng trường lẻ khi UI cần thay đổi
  /// (ví dụ: người dùng đổi ngôn ngữ hoặc cập nhật biển số xe)
  ProfileEntity copyWith({
    String? fullName,
    String? email,
    String? avatarUrl,
    String? phoneNumber,
    String? gender,
    String? vehicleType,
    String? vehicleBrand,
    String? plateNumber,
    String? language,
    double? rating,
  }) {
    return ProfileEntity(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      plateNumber: plateNumber ?? this.plateNumber,
      language: language ?? this.language,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    plateNumber,
    avatarUrl,
    gender,
    vehicleType,
    vehicleBrand,
    language,
    rating,
  ];
}