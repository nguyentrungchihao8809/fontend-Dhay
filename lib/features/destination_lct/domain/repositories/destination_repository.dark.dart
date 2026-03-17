import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
// Đảm bảo đường dẫn này trỏ đúng vào file entity trong thư mục destination_lct
import '../entities/location_entity.dart';

abstract class DestinationRepository {
  Future<Either<Failure, LocationEntity>> getAddressFromCoords(double lat, double lng);
}