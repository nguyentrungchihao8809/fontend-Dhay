import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/payment_method_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<bool> processPayment(Map<String, dynamic> data);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;
  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      return [
        const PaymentMethodModel(
            id: 'cash_1',
            name: 'Thanh toán tiền',
            icon: 'assets/icons/money.png', // Đã thay money.png
            type: 'CASH'
        ),
        const PaymentMethodModel(
            id: 'momo_1',
            name: 'Thanh toán MoMo',
            icon: 'assets/icons/momo.png',
            type: 'WALLET'
        ),
        const PaymentMethodModel(
            id: 'zalopay_1',
            name: 'Thanh toán ZaloPay',
            icon: 'assets/icons/ZaloPay.png', // Viết hoa Z P theo list của em
            type: 'WALLET'
        ),
        const PaymentMethodModel(
            id: 'vnpay_1',
            name: 'Thanh toán VnPay',
            icon: 'assets/icons/VNpay.png', // Viết hoa VN theo list của em
            type: 'WALLET'
        ),
        const PaymentMethodModel(
            id: 'vietqr_1',
            name: 'Thanh toán VietQR',
            icon: 'assets/icons/VietQR.png', // Viết hoa V QR theo list của em
            type: 'WALLET'
        ),
      ];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> processPayment(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}