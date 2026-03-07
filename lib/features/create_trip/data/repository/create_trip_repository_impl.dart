// lib/features/create_trip/data/repository/create_trip_repository_impl.dart
import '../../domain/entity/create_trip_location_entity.dart';
import '../../domain/repository/create_trip_repository.dart';
import '../datasources/create_trip_remote_datasource.dart';

class CreateTripRepositoryImpl implements CreateTripRepository {
  final CreateTripRemoteDataSource remoteDataSource;

  CreateTripRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CreateTripLocationEntity>> searchLocations(String query) async {
    // Vì Model kế thừa từ Entity nên trả về trực tiếp được
    return await remoteDataSource.searchLocations(query);
  }
}