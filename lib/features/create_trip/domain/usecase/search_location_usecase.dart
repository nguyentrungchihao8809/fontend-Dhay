import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repository/create_trip_repository.dart';
import '../entity/create_trip_location_entity.dart';



class SearchLocationUseCase {
  final CreateTripRepository repository;

  SearchLocationUseCase(this.repository);

  Future<Either<Failure, List<CreateTripLocationEntity>>> call(String query) async {
    if (query.trim().isEmpty) return const Right([]);
    try {
      final results = await repository.searchLocations(query);
      return Right(results);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}