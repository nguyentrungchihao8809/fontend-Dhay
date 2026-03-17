import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/pickup_repository.dart';

// --- Events ---
abstract class PickupEvent {}
class MapCameraMoved extends PickupEvent {
  final double lat;
  final double lng;
  MapCameraMoved(this.lat, this.lng);
}

// --- States ---
abstract class PickupState {}
class PickupInitial extends PickupState {}
class PickupLoading extends PickupState {}
class PickupLoaded extends PickupState {
  final String name;
  final String address;
  PickupLoaded(this.name, this.address);
}
class PickupError extends PickupState {
  final String message;
  PickupError(this.message);
}

// --- Bloc ---
class PickupBloc extends Bloc<PickupEvent, PickupState> {
  final PickupRepository repository;

  PickupBloc(this.repository) : super(PickupInitial()) {
    on<MapCameraMoved>((event, emit) async {
      emit(PickupLoading());

      final result = await repository.getAddressFromCoords(event.lat, event.lng);

      result.fold(
        // Lấy failure.message từ class Failure cũ của bạn
            (failure) => emit(PickupError(failure.message)),
            (location) => emit(PickupLoaded(location.name, location.address)),
      );
    });
  }
}