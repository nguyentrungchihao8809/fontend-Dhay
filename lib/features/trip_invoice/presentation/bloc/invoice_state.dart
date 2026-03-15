import 'package:equatable/equatable.dart'; // Hết chữ lạ rồi nhaimport '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_entity.dart';

abstract class InvoiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvoiceInitial extends InvoiceState {}
class InvoiceLoading extends InvoiceState {}
class InvoiceLoaded extends InvoiceState {
  final InvoiceEntity invoice;
  InvoiceLoaded(this.invoice);
}
class InvoiceError extends InvoiceState {
  final String message;
  InvoiceError(this.message);
}