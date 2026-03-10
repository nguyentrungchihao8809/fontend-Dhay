import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/driver_repository.dart';

class CheckDriverStatusUseCase {
  final DriverRepository repository;

  CheckDriverStatusUseCase(this.repository);

  /// Trả về Right(true) nếu đã đăng ký, Right(false) nếu chưa,
  /// hoặc Left(Failure) nếu có lỗi xảy ra.
  Future<Either<Failure, bool>> call() async {
    return await repository.checkDriverStatus();
  }
}