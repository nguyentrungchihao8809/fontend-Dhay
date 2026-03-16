import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/location_model.dart';

abstract class TripRemoteDataSource {
  Future<List<LocationModel>> searchLocation(String query);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final Dio dio;

  TripRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<LocationModel>> searchLocation(String query) async {
    try {
      final response = await dio.get(
        '${ApiConstants.mapboxBaseUrl}/$query.json',
        queryParameters: {
          'access_token': ApiConstants.mapboxToken,
          'country': 'vn',
          'limit': 5,
        },
      );

      if (response.statusCode == 200) {
        final List features = response.data['features'];
        return features.map((json) => LocationModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch data from Mapbox');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}