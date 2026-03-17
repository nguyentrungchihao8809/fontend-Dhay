// lib/features/destination_lct/data/datasources/destination_remote_datasource.dart
import '../../../../core/errors/exceptions.dart';
import '../models/location_model.dart';

abstract class DestinationRemoteDataSource {
  Future<LocationModel> getAddressFromCoords(double lat, double lng);
}

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  @override
  Future<LocationModel> getAddressFromCoords(double lat, double lng) async {
    try {
      // Giả lập lấy dữ liệu cho điểm đến
      await Future.delayed(const Duration(seconds: 1));

      // Bạn có thể đổi địa chỉ giả lập khác để phân biệt với điểm đón
      return const LocationModel(
        name: "Bitexco Financial Tower",
        address: "2 Hải Triều, Bến Nghé, Quận 1, TP.HCM",
      );
    } catch (e) {
      // Giữ nguyên logic xử lý lỗi của bạn
      throw ServerException(message: "Không thể lấy địa chỉ điểm đến từ bản đồ");
    }
  }
}