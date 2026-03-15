import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/invoice_repository.dart';

class GetInvoiceDetails {
  final InvoiceRepository repository;
  GetInvoiceDetails(this.repository);

  Future<Either<Failure, InvoiceEntity>> call(String tripId) async {
    return await repository.getInvoiceDetails(tripId);
  }
}