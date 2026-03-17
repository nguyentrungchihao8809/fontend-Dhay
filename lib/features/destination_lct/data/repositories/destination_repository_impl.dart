import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/destination_repository.dart';
import '../datasources/destination_remote_datasource.dart';

// Đã đổi tên từ PickupRepositoryImpl thành DestinationRepositoryImpl
class DestinationRepositoryImpl implements DestinationRepository {
  final DestinationRemoteDataSource remoteDataSource;

  DestinationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LocationEntity>> getAddressFromCoords(double lat, double lng) async {
    try {
      // Gọi đến DestinationRemoteDataSource
      final remoteLocation = await remoteDataSource.getAddressFromCoords(lat, lng);
      return Right(remoteLocation);
    } on ServerException catch (e) {
      // Trả về ServerFailure cho điểm đến
      return Left(ServerFailure(e.message ?? "Lỗi kết nối Server khi lấy địa chỉ đến"));
    } catch (e) {
      return Left(ServerFailure("Lỗi phát sinh không xác định tại điểm đến"));
    }
  }
}