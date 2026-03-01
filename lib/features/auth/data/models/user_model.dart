import '../../../../core/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // BE trả về 'userId', FE cần gán vào 'id'
      id: json['userId']?.toString() ?? json['id']?.toString() ?? '',

      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',

      // Khi gọi /me, BE không trả về token.
      // Ta để mặc định là rỗng, AuthBloc sẽ dùng copyWith để giữ lại token cũ từ máy.
      token: json['accessToken'] ?? '',
    );
  }

  // Hàm này cực kỳ quan trọng để "giữ" token cũ khi BE trả về accessToken = null
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}