import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/driver_registration.dart';
import '../../domain/repositories/driver_repository.dart';
import '../datasources/driver_remote_data_source.dart';
import '../models/driver_registration_model.dart';
import '../datasources/driver_local_data_source.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDataSource remoteDataSource;
  final DriverLocalDataSource localDataSource; // Thêm local

  DriverRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> registerDriver(DriverRegistration registration) async {
    try {
      final model = DriverRegistrationModel.fromEntity(registration);
      final vehicleId = await remoteDataSource.registerDriver(model);

      // LƯU VÀO MÁY NGAY SAU KHI REMOTE THÀNH CÔNG
      await localDataSource.cacheDriverStatus(vehicleId);

      return Right(vehicleId);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}