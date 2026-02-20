import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Thêm SharedPreferences
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../models/social_login_request.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String identifier, String password);
  Future<UserModel> register(String fullName, String identifier, String password);
  Future<UserModel> socialLogin(SocialLoginRequest request);
  Future<UserModel> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      throw ServerException(message: "Không tìm thấy phiên đăng nhập");
    }

    // Giả sử Backend có endpoint /auth/me để kiểm tra token
    // Nếu chưa có ApiConstants.getProfile, hãy thêm nó vào file constants
    final response = await client.get(
      Uri.parse(ApiConstants.baseUrl + "/auth/me"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Gửi Token lên để xác thực
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      // Nếu server trả về 401 hoặc lỗi, ném lỗi để Bloc nhảy vào catch
      throw ServerException(message: "Phiên đăng nhập hết hạn");
    }
  }

  // --- Các hàm cũ giữ nguyên ---
  @override
  Future<UserModel> login(String identifier, String password) async {
    final response = await client.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
        'provider': 'LOCAL',
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> register(String fullName, String identifier, String password) async {
    final response = await client.post(
      Uri.parse(ApiConstants.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'identifier': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(message: "Đăng ký thất bại: ${response.body}");
    }
  }

  @override
  Future<UserModel> socialLogin(SocialLoginRequest request) async {
    final response = await client.post(
      Uri.parse(ApiConstants.socialLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(message: "Lỗi đăng nhập mạng xã hội");
    }
  }
}