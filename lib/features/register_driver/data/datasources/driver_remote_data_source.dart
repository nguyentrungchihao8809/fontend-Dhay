import 'dart:convert';
import 'package:http/http.dart' as http; // Hoặc sử dụng Dio tùy dự án
import '../../../../core/errors/exceptions.dart';
import '../models/driver_registration_model.dart';

import '../../../../core/constants/api_constants.dart';


abstract class DriverRemoteDataSource {
  Future<String> registerDriver(DriverRegistrationModel model);
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final http.Client client;

  DriverRemoteDataSourceImpl({required this.client});

  @override
  Future<String> registerDriver(DriverRegistrationModel model) async {
    final response = await client.post(
      Uri.parse(ApiConstants.registerDriver),
      headers: {
        'Content-Type': 'application/json',
        // Token logic should be handled by an Interceptor or passed here
        'Authorization': 'Bearer YOUR_TOKEN_HERE',
      },
      body: json.encode(model.toJson()),
    );

    if (response.statusCode == 200) {
      // API return idVehicle in plain text or wrapped in JSON
      // As per requirement: "cần trả về idVehicle để FE lưu tạm"
      return response.body;
    } else {
      throw ServerException();
    }
  }
}