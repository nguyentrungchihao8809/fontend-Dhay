import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/payment_repository.dart';

class ProcessPayment {
  final PaymentRepository repository;
  ProcessPayment(this.repository);

  Future<Either<Failure, bool>> call({
    required String orderId,
    required String paymentMethodId,
    required double amount,
  }) async {
    return await repository.processPayment(
      orderId: orderId,
      paymentMethodId: paymentMethodId,
      amount: amount,
    );
  }
}