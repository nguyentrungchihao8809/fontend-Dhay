import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String type;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, icon, type];
}