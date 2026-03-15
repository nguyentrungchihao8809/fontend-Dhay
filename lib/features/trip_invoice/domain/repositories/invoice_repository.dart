import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, InvoiceEntity>> getInvoiceDetails(String tripId);
}