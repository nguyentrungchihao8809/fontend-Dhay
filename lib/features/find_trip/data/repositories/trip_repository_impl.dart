import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_data_source.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LocationEntity>>> searchLocation(String query) async {
    try {
      final remoteData = await remoteDataSource.searchLocation(query);
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? "Server Error"));
    } catch (e) {
      return Left(ServerFailure("An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getRecentTrips() async {
    // Mock data based on Figma for demonstration
    // In real app, this would call TripLocalDataSource
    try {
      final List<LocationEntity> mockHistory = [
        const LocationEntity(
            id: '1',
            name: 'Emart Phan Huy Ích',
            address: '385 Phan Huy Ích, phường 4, quận Gò Vấp, TP. Hồ Chí Minh',
            distance: 2.6
        ),
        const LocationEntity(
            id: '2',
            name: 'Trường Đại học GTVT TP. Hồ Chí Minh',
            address: '70 Tô Ký, quận 12, TP. Hồ Chí Minh',
            distance: 3.5
        ),
        const LocationEntity(
            id: '3',
            name: 'The Landmark 81',
            address: '208 Nguyễn Hữu Cảnh, phường 22, quận Bình Thạnh, TP. Hồ Chí Minh',
            distance: 17.0
        ),
      ];
      return Right(mockHistory);
    } catch (e) {
      return Left(ServerFailure("Cannot load history"));
    }
  }
}