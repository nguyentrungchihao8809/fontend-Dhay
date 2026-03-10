import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/driver_registration.dart';

abstract class DriverRepository {
  /// Đăng ký tài xế
  Future<Either<Failure, String>> registerDriver(DriverRegistration registration);

  /// KIỂM TRA TRẠNG THÁI (Thêm dòng này để hết lỗi)
  Future<Either<Failure, bool>> checkDriverStatus();
}