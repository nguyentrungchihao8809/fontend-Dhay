import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_invoice_details.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GetInvoiceDetails getInvoiceDetails;

  InvoiceBloc({required this.getInvoiceDetails}) : super(InvoiceInitial()) {
    on<FetchInvoiceDetails>((event, emit) async {
      emit(InvoiceLoading());
      final result = await getInvoiceDetails(event.tripId);
      result.fold(
            (failure) => emit(InvoiceError(failure.message)),
            (invoice) => emit(InvoiceLoaded(invoice)),
      );
    });
  }
}