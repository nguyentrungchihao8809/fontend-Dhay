// lib/features/create_trip/data/datasources/create_trip_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/create_trip_location_model.dart';

abstract class CreateTripRemoteDataSource {
  /// Gọi Mapbox Geocoding API để tìm kiếm địa điểm
  Future<List<CreateTripLocationModel>> searchLocations(String query);
}

class CreateTripRemoteDataSourceImpl implements CreateTripRemoteDataSource {
  final Dio dio;

  CreateTripRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CreateTripLocationModel>> searchLocations(String query) async {
    try {
      // Dio sẽ tự động xử lý Encode URL khi bạn truyền vào queryParameters
      final response = await dio.get(
        "${ApiConstants.mapboxBaseUrl}/${Uri.encodeComponent(query)}.json",
        queryParameters: {
          'access_token': ApiConstants.mapboxToken,
          'country': 'VN',
          'language': 'vi',
          'limit': 10,
          'autocomplete': 'true', // Thêm cái này để hỗ trợ gợi ý tốt hơn
        },
      );

      if (response.statusCode == 200) {
        // Lấy danh sách features từ dữ liệu trả về
        // Với Dio, response.data đã là Map rồi nên không cần jsonDecode thủ công
        final List features = response.data['features'];

        // Chuyển đổi từ JSON sang Model (Sử dụng hàm fromJson đã cập nhật tọa độ của bạn)
        return features
            .map((json) => CreateTripLocationModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(message: "Không thể lấy dữ liệu từ Mapbox");
      }
    } on DioException catch (e) {
      // Xử lý lỗi riêng cho Dio
      throw ServerException(message: e.message ?? "Lỗi kết nối mạng");
    } catch (e) {
      // Các lỗi phát sinh khác trong quá trình map dữ liệu
      throw ServerException(message: e.toString());
    }
  }
}