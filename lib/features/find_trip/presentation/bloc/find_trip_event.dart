import 'package:equatable/equatable.dart';

abstract class FindTripEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRecentTripsEvent extends FindTripEvent {}

class SwapLocationsEvent extends FindTripEvent {
  final String pickup;
  final String destination;
  SwapLocationsEvent(this.pickup, this.destination);
}