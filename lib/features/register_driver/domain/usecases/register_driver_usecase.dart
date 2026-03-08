import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/driver_registration.dart';
import '../repositories/driver_repository.dart';

class RegisterDriverUsecase {
  final DriverRepository repository;

  RegisterDriverUsecase(this.repository);

  Future<Either<Failure, String>> call(DriverRegistration registration) async {
    return await repository.registerDriver(registration);
  }
}