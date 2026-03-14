import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart'; // Đảm bảo có dartz để handle kết quả fold

// Sửa lại đường dẫn import chính xác theo cấu trúc folder chuẩn
import '../../domain/usecases/get_payment_methods.dart';
import '../../domain/usecases/process_payment.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetPaymentMethods getPaymentMethods;
  final ProcessPayment processPayment;

  PaymentBloc({
    required this.getPaymentMethods,
    required this.processPayment,
  }) : super(PaymentInitial()) {

    // 1. Xử lý sự kiện lấy danh sách phương thức thanh toán
    on<GetPaymentMethodsEvent>((event, emit) async {
      emit(PaymentLoading());

      // Thực thi usecase (gọi call method)
      final failureOrMethods = await getPaymentMethods();

      failureOrMethods.fold(
            (failure) => emit(PaymentFailure(failure.message)),
            (methods) => emit(PaymentLoaded(
          methods: methods,
          // Mặc định chọn phương thức đầu tiên nếu danh sách không rỗng
          selectedMethodId: methods.isNotEmpty ? methods.first.id : '',
        )),
      );
    });

    // 2. Xử lý sự kiện thay đổi phương thức thanh toán (chọn từ UI)
    on<SelectPaymentMethodEvent>((event, emit) {
      final currentState = state;
      if (currentState is PaymentLoaded) {
        // Sử dụng copyWith để giữ nguyên list methods, chỉ đổi selectedId
        emit(currentState.copyWith(selectedMethodId: event.methodId));
      }
    });

    // 3. Xử lý sự kiện xác nhận thanh toán (nút "Thanh Toán")
    on<ConfirmPaymentEvent>((event, emit) async {
      final currentState = state;
      if (currentState is PaymentLoaded) {
        final selectedId = currentState.selectedMethodId;

        // Nếu chưa chọn phương thức nào thì báo lỗi nhẹ
        if (selectedId.isEmpty) {
          emit(const PaymentFailure("Vui lòng chọn phương thức thanh toán"));
          return;
        }

        emit(PaymentLoading());

        final failureOrSuccess = await processPayment(
          orderId: "TEMP_ORDER_ID", // ID này sẽ được truyền từ params UI nếu cần
          paymentMethodId: selectedId,
          amount: event.amount,
        );

        failureOrSuccess.fold(
              (failure) => emit(PaymentFailure(failure.message)),
              (_) => emit(PaymentSuccess()),
        );
      }
    });
  }
}