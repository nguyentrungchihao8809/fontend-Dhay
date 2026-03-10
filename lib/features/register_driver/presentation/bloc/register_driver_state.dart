import 'package:equatable/equatable.dart';

abstract class RegisterDriverState extends Equatable {
  const RegisterDriverState();

  @override
  List<Object> get props => [];
}

class RegisterDriverInitial extends RegisterDriverState {}

class RegisterDriverLoading extends RegisterDriverState {}

/// TRẠNG THÁI MỚI: Trả về kết quả kiểm tra tài xế (True/False)
class DriverStatusResult extends RegisterDriverState {
  final bool isRegistered;

  const DriverStatusResult(this.isRegistered);

  @override
  List<Object> get props => [isRegistered];
}

class RegisterDriverSuccess extends RegisterDriverState {
  final String vehicleId;
  final String message;

  const RegisterDriverSuccess({required this.vehicleId, required this.message});

  @override
  List<Object> get props => [vehicleId, message];
}

class RegisterDriverFailure extends RegisterDriverState {
  final String message;

  const RegisterDriverFailure(this.message);

  @override
  List<Object> get props => [message];
}