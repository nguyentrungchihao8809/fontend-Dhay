import 'package:equatable/equatable.dart';
// Đảm bảo đường dẫn này khớp với file entity bạn đã tạo ở bước trước
import '../../domain/entities/payment_method.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi tạo của tính năng
class PaymentInitial extends PaymentState {}

/// Trạng thái đang xử lý (Loading khi lấy danh sách hoặc khi đang bấm nút thanh toán)
class PaymentLoading extends PaymentState {}

/// Trạng thái đã tải xong danh sách phương thức thanh toán
class PaymentLoaded extends PaymentState {
  final List<PaymentMethod> methods;
  final String selectedMethodId;

  const PaymentLoaded({
    required this.methods,
    this.selectedMethodId = '',
  });

  /// Hàm copyWith giúp tạo ra một instance mới từ instance cũ
  /// nhưng thay đổi một vài giá trị nhất định (quan trọng cho BLoC)
  PaymentLoaded copyWith({
    List<PaymentMethod>? methods,
    String? selectedMethodId,
  }) {
    return PaymentLoaded(
      methods: methods ?? this.methods,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
    );
  }

  @override
  List<Object?> get props => [methods, selectedMethodId];
}

/// Trạng thái thanh toán thành công
class PaymentSuccess extends PaymentState {}

/// Trạng thái xảy ra lỗi (ServerFailure, v.v.)
class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}