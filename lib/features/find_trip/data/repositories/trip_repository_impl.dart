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
            name: 'Phan Huy Ich Emart',
            address: '385 Phan Huy Ich Street, Ward 4, Go Vap District',
            distance: 2.6
        ),
        const LocationEntity(
            id: '2',
            name: 'University of Transport Ho Chi Minh City',
            address: '70 To Ky Street, Ho Chi Minh City',
            distance: 3.5
        ),
        const LocationEntity(
            id: '3',
            name: 'The Landmark 81',
            address: '208 Nguyen Huu Canh Street, Ward 22, Binh Thanh District',
            distance: 17.0
        ),
      ];
      return Right(mockHistory);
    } catch (e) {
      return Left(ServerFailure("Cannot load history"));
    }
  }
}