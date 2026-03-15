import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<InvoiceModel> getInvoiceDetails(String tripId);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio dio;
  InvoiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<InvoiceModel> getInvoiceDetails(String tripId) async {
    try {
      // Giả định API endpoint
      final response = await dio.get('/trips/$tripId/invoice');
      if (response.statusCode == 200) {
        return InvoiceModel.fromJson(response.data);
      } else {
        throw ServerException(message: "Không thể lấy thông tin hóa đơn");
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}