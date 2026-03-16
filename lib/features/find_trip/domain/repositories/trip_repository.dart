import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/location_entity.dart';

abstract class TripRepository {
  // Get search history from local
  Future<Either<Failure, List<LocationEntity>>> getRecentTrips();

  // Search location from remote API
  Future<Either<Failure, List<LocationEntity>>> searchLocation(String query);
}