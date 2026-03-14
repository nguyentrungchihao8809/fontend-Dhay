import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final remoteMethods = await remoteDataSource.getPaymentMethods();
      return Right(remoteMethods);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? "Lỗi server"));
    }
  }

  @override
  Future<Either<Failure, bool>> processPayment({
    required String orderId,
    required String paymentMethodId,
    required double amount,
  }) async {
    try {
      final result = await remoteDataSource.processPayment({
        'order_id': orderId,
        'payment_id': paymentMethodId,
        'amount': amount,
      });
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? "Thanh toán thất bại"));
    }
  }
}