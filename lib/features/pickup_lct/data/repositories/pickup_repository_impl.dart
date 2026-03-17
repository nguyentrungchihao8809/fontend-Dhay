import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/pickup_repository.dart';
import '../datasources/pickup_remote_datasource.dart';

class PickupRepositoryImpl implements PickupRepository {
  final PickupRemoteDataSource remoteDataSource;

  PickupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LocationEntity>> getAddressFromCoords(double lat, double lng) async {
    try {
      final remoteLocation = await remoteDataSource.getAddressFromCoords(lat, lng);
      return Right(remoteLocation);
    } on ServerException catch (e) {
      // Trả về ServerFailure khớp với class cũ (không dùng const)
      return Left(ServerFailure(e.message ?? "Lỗi kết nối Server"));
    } catch (e) {
      return Left(ServerFailure("Lỗi phát sinh không xác định"));
    }
  }
}