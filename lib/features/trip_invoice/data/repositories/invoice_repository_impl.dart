import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_remote_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;
  InvoiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, InvoiceEntity>> getInvoiceDetails(String tripId) async {
    try {
      // Trong thực tế sẽ gọi: await remoteDataSource.getInvoiceDetails(tripId);
      // Giờ anh giả lập dữ liệu để cục cưng thấy UI luôn nhé:
      await Future.delayed(const Duration(seconds: 1)); // Giả lập chờ mạng

      return const Right(InvoiceEntity(
        date: "30-10-2026",
        time: "03:08 CH",
        duration: "10 phút",
        distance: "3.5km",
        totalFare: 38000,
        voucherDiscount: 7900,
        subTotal: 30100,
        driverName: "Văn Boi",
        driverRating: 4.3,
        vehiclePlate: "Vison . 66H1 - 559.64",
        pickupTime: "3:08 CH",
        pickupLocation: "Nhà Thờ Đức Bà",
        pickupAddress: "Phường Bến Nghé, Quận 1, Tp.Hồ Chí Minh",
        dropoffTime: "3:18 CH",
        dropoffLocation: "Bưu điện thành phố",
        dropoffAddress: "Phường Bến Nghé, Quận 1, Tp.Hồ Chí Minh",
      ));
    } catch (e) {
      return Left(ServerFailure("Không thể tải hóa đơn"));
    }
  }
}