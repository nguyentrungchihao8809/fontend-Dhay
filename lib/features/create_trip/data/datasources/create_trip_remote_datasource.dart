// lib/features/create_trip/data/datasources/create_trip_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/create_trip_location_model.dart';

abstract class CreateTripRemoteDataSource {
  Future<List<CreateTripLocationModel>> searchLocations(String query);
}

class CreateTripRemoteDataSourceImpl implements CreateTripRemoteDataSource {
  final Dio dio;
  CreateTripRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CreateTripLocationModel>> searchLocations(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await dio.get(
        "${ApiConstants.mapboxBaseUrl}/$encodedQuery.json",
        queryParameters: {
          'access_token': ApiConstants.mapboxToken,
          'country': 'VN',
          'language': 'vi',
          'limit': 10,
        },
      );

      if (response.statusCode == 200) {
        final List features = response.data['features'];
        return features.map((json) => CreateTripLocationModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}