import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class GetPaymentMethodsEvent extends PaymentEvent {}

class SelectPaymentMethodEvent extends PaymentEvent {
  final String methodId;
  const SelectPaymentMethodEvent(this.methodId);
  @override
  List<Object?> get props => [methodId];
}

class ConfirmPaymentEvent extends PaymentEvent {
  final double amount;
  const ConfirmPaymentEvent(this.amount);
  @override
  List<Object?> get props => [amount];
}