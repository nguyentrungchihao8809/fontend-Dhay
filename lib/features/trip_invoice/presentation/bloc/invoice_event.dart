import 'package:equatable/equatable.dart'; // Đã sửa sạch sẽ rồi nè cục cưng
abstract class InvoiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchInvoiceDetails extends InvoiceEvent {
  final String tripId;
  FetchInvoiceDetails(this.tripId);
}