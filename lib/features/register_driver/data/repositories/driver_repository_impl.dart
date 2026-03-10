import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/driver_registration.dart';
import '../../domain/repositories/driver_repository.dart';
import '../datasources/driver_remote_data_source.dart';
import '../datasources/driver_local_data_source.dart';
import '../models/driver_registration_model.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDataSource remoteDataSource;
  final DriverLocalDataSource localDataSource;

  DriverRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> registerDriver(DriverRegistration registration) async {
    try {
      // 1. Chuyển Entity sang Model để gửi đi
      final model = DriverRegistrationModel.fromEntity(registration);

      // 2. Gọi Remote
      final vehicleId = await remoteDataSource.registerDriver(model);

      // 3. Cache lại trạng thái đăng ký vào Local (SharedPref)
      await localDataSource.cacheDriverStatus(vehicleId);

      return Right(vehicleId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? "Lỗi đăng ký từ Server"));
    } catch (e) {
      return Left(ServerFailure("Đã xảy ra lỗi không xác định"));
    }
  }

  @override
  Future<Either<Failure, bool>> checkDriverStatus() async {
    try {
      // 1. Kiểm tra từ Remote (API)
      final isRegistered = await remoteDataSource.checkRegistration();

      // 2. Nếu đã đăng ký, đồng bộ luôn vào Local
      if (isRegistered) {
        // Lưu một giá trị đánh dấu (ví dụ "REGISTERED")
        // để logic các phần khác trong app có thể dùng offline
        await localDataSource.cacheDriverStatus("REGISTERED");
      }

      return Right(isRegistered);
    } on ServerException catch (e) {
      // Nếu lỗi Server, ta có thể thử lấy từ Local ra làm phương án dự phòng (optional)
      return Left(ServerFailure(e.message ?? "Lỗi kết nối Server"));
    } catch (e) {
      return Left(ServerFailure("Lỗi kiểm tra trạng thái"));
    }
  }
}