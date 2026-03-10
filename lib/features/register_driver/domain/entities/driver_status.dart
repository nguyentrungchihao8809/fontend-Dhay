import 'package:equatable/equatable.dart';

class DriverStatus extends Equatable {
  final bool isRegistered;
  final String message;

  const DriverStatus({required this.isRegistered, required this.message});

  @override
  List<Object?> get props => [isRegistered, message];
}