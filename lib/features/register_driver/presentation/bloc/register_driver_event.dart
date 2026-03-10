import 'package:equatable/equatable.dart';
import '../../domain/entities/driver_registration.dart';

abstract class RegisterDriverEvent extends Equatable {
  const RegisterDriverEvent();

  @override
  List<Object> get props => [];
}

class OnRegisterSubmit extends RegisterDriverEvent {
  final DriverRegistration registration;

  const OnRegisterSubmit(this.registration);

  @override
  List<Object> get props => [registration];
}

class OnCheckDriverStatus extends RegisterDriverEvent {}