import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/trip_repository.dart';
import 'find_trip_event.dart';
import 'find_trip_state.dart';

class FindTripBloc extends Bloc<FindTripEvent, FindTripState> {
  final TripRepository repository;

  FindTripBloc({required this.repository}) : super(FindTripInitial()) {
    on<LoadRecentTripsEvent>((event, emit) async {
      emit(FindTripLoading());
      final result = await repository.getRecentTrips();
      result.fold(
            (failure) => emit(FindTripError(failure.message)),
            (trips) => emit(FindTripLoaded(recentTrips: trips)),
      );
    });

    on<SwapLocationsEvent>((event, emit) {
      // Logic handling swapping in UI controllers via state if needed
    });
  }
}