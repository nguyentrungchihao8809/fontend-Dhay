import 'package:equatable/equatable.dart';
import '../../domain/entities/location_entity.dart';

abstract class FindTripState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FindTripInitial extends FindTripState {}

class FindTripLoading extends FindTripState {}

class FindTripLoaded extends FindTripState {
  final List<LocationEntity> recentTrips;
  FindTripLoaded({required this.recentTrips});

  @override
  List<Object?> get props => [recentTrips];
}

class FindTripError extends FindTripState {
  final String message;
  FindTripError(this.message);

  @override
  List<Object?> get props => [message];
}