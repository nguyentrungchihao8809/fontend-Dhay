import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/driver_registration_model.dart';

abstract class DriverRemoteDataSource {
  /// Đăng ký trở thành tài xế
  Future<String> registerDriver(DriverRegistrationModel model);

  /// Kiểm tra xem user hiện tại đã là tài xế chưa
  Future<bool> checkRegistration();
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final http.Client client;

  DriverRemoteDataSourceImpl({required this.client});

  @override
  Future<String> registerDriver(DriverRegistrationModel model) async {
    final String? token = await _getToken();

    final response = await client.post(
      Uri.parse(ApiConstants.registerDriver),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(model.toJson()),
    );

    if (response.statusCode == 200) {
      // Trả về idVehicle (plain text hoặc json tùy BE)
      return response.body;
    } else {
      throw ServerException(message: "Đăng ký thất bại. Vui lòng thử lại.");
    }
  }

  @override
  Future<bool> checkRegistration() async {
    final String? token = await _getToken();

    final response = await client.get(
      Uri.parse("${ApiConstants.drivers}/check-registration"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Dựa trên response BE: {"isRegistered": true, "message": "..."}
      return data['isRegistered'] ?? false;
    } else {
      throw ServerException(message: "Không thể kiểm tra trạng thái tài xế.");
    }
  }

  /// Helper lấy token từ máy
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}