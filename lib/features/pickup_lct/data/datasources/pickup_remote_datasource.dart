import '../../../../core/errors/exceptions.dart';
import '../models/location_model.dart';

abstract class PickupRemoteDataSource {
  Future<LocationModel> getAddressFromCoords(double lat, double lng);
}

class PickupRemoteDataSourceImpl implements PickupRemoteDataSource {
  @override
  Future<LocationModel> getAddressFromCoords(double lat, double lng) async {
    try {
      // Giả lập lấy dữ liệu
      await Future.delayed(const Duration(seconds: 1));
      return const LocationModel(
        name: "The Landmark 81",
        address: "208 đường Nguyễn Hữu Cảnh, Bình Thạnh, TP.HCM",
      );
    } catch (e) {
      // Dùng đúng constructor ServerException({this.message}) của bạn
      throw ServerException(message: "Không thể lấy địa chỉ từ bản đồ");
    }
  }
}