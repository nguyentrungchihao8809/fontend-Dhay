import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/driver_registration.dart';

abstract class DriverRepository {
  /// Registers a passenger as a driver
  /// Returns the vehicleId as a String on success
  Future<Either<Failure, String>> registerDriver(DriverRegistration registration);
}