import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart'; // Đảm bảo đúng thư mục 'errors' có s
import '../entities/location_entity.dart';

abstract class PickupRepository {
  Future<Either<Failure, LocationEntity>> getAddressFromCoords(double lat, double lng);
}