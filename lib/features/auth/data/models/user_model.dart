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
      // BE trả về Long (số), nên phải toString() để khớp với Entity String
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      // BE dùng accessToken. Nếu là getProfile thì trường này sẽ null,
      // nên ta dùng ?? '' để tránh lỗi.
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