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

  // Hàm helper để parse lỗi từ server (Tránh lặp lại code)
  Never _handleError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      throw ServerException(message: data['message'] ?? "Đã có lỗi xảy ra");
    } catch (_) {
      throw ServerException(message: "Lỗi hệ thống (${response.statusCode})");
    }
  }

  @override
  Future<UserModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      throw ServerException(message: "Không tìm thấy phiên đăng nhập");
    }

    final response = await client.get(
      Uri.parse("${ApiConstants.baseUrl}/v1/users/me"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Ép kiểu utf8.decode để tránh lỗi tiếng Việt
      return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw ServerException(message: "Phiên đăng nhập hết hạn");
    }
  }

  @override
  Future<UserModel> login(String identifier, String password) async {
    final response = await client.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
        'provider': 'LOCAL',
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      _handleError(response);
    }
  }

  @override
  Future<UserModel> register(String fullName, String identifier, String password) async {
    final response = await client.post(
      Uri.parse(ApiConstants.register),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'fullName': fullName,
        'identifier': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      _handleError(response);
      throw ServerException();
    }
  }

  @override
  Future<UserModel> socialLogin(SocialLoginRequest request) async {
    final response = await client.post(
      Uri.parse(ApiConstants.socialLogin),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      _handleError(response);
      throw ServerException();
    }
  }
}