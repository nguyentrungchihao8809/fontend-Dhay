import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/destination_repository.dart';

// --- Events ---
abstract class DestinationEvent {} // Đổi tên

class DestinationMapCameraMoved extends DestinationEvent { // Đổi tên
  final double lat;
  final double lng;
  DestinationMapCameraMoved(this.lat, this.lng);
}

// --- States ---
abstract class DestinationState {} // Đổi tên

class DestinationInitial extends DestinationState {}

class DestinationLoading extends DestinationState {}

class DestinationLoaded extends DestinationState {
  final String name;
  final String address;
  DestinationLoaded(this.name, this.address);
}

class DestinationError extends DestinationState {
  final String message;
  DestinationError(this.message);
}

// --- Bloc ---
class DestinationBloc extends Bloc<DestinationEvent, DestinationState> {
  final DestinationRepository repository; // Đã trỏ đúng vào DestinationRepository

  DestinationBloc(this.repository) : super(DestinationInitial()) {
    on<DestinationMapCameraMoved>((event, emit) async {
      emit(DestinationLoading());

      final result = await repository.getAddressFromCoords(event.lat, event.lng);

      result.fold(
            (failure) => emit(DestinationError(failure.message)),
            (location) => emit(DestinationLoaded(location.name, location.address)),
      );
    });
  }
}