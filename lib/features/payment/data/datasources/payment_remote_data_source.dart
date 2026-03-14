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
      // Demo dữ liệu đầy đủ 5 phương thức theo Ảnh 3
      return [
        const PaymentMethodModel(
            id: 'cash_1',
            name: 'Thanh toán tiền',
            icon: '',
            type: 'CASH'
        ),
        const PaymentMethodModel(
            id: 'momo_1',
            name: 'Thanh toán MoMo',
            icon: 'assets/images/momo.png',
            type: 'WALLET'
        ),
        const PaymentMethodModel(
            id: 'zalopay_1',
            name: 'Thanh toán ZaloPay',
            icon: 'assets/images/zalopay.png',
            type: 'WALLET'
        ),
        const PaymentMethodModel(
            id: 'vnpay_1',
            name: 'Thanh toán VnPay',
            icon: 'assets/images/vnpay.png',
            type: 'WALLET'
        ),
        const PaymentMethodModel(
            id: 'vietqr_1',
            name: 'Thanh toán VietQR',
            icon: 'assets/images/vietqr.png',
            type: 'WALLET'
        ),
      ];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> processPayment(Map<String, dynamic> data) async {
    // Giả lập xử lý thanh toán mất 1 giây
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}