import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/create_trip_location_entity.dart';
import '../../domain/entity/saved_trip_entity.dart';
import '../../domain/usecase/search_location_usecase.dart';
import '../../domain/entity/trip_route_entity.dart';
import '../../../../core/constants/api_constants.dart';

/// ================= ENUM =================
enum LocationFieldType { pickup, dropoff }

/// ================= EVENTS =================
abstract class CreateTripEvent {}

class SearchQueryChanged extends CreateTripEvent {
  final String query;
  final LocationFieldType fieldType;
  SearchQueryChanged(this.query, this.fieldType);
}

class _FetchLocationsInternal extends CreateTripEvent {
  final String query;
  final LocationFieldType fieldType;
  _FetchLocationsInternal(this.query, this.fieldType);
}

class SelectLocationEvent extends CreateTripEvent {
  final CreateTripLocationEntity location;
  final LocationFieldType fieldType;
  SelectLocationEvent(this.location, this.fieldType);
}

class AddSavedTripEvent extends CreateTripEvent {
  final SavedTripEntity trip;
  AddSavedTripEvent(this.trip);
}

/// ================= STATES =================
abstract class CreateTripState {
  final List<CreateTripLocationEntity> pickupResults;
  final List<CreateTripLocationEntity> dropoffResults;
  final CreateTripLocationEntity? selectedPickup;
  final CreateTripLocationEntity? selectedDropoff;
  final List<SavedTripEntity> savedTrips;
  // Đưa routeSuggestions lên đây để Page luôn truy cập được
  final List<TripRouteEntity> routeSuggestions;

  CreateTripState({
    this.pickupResults = const [],
    this.dropoffResults = const [],
    this.selectedPickup,
    this.selectedDropoff,
    this.savedTrips = const [],
    this.routeSuggestions = const [],
  });
}

class CreateTripInitial extends CreateTripState {
  CreateTripInitial({super.savedTrips});
}

class CreateTripLoading extends CreateTripState {
  CreateTripLoading({
    super.pickupResults,
    super.dropoffResults,
    super.selectedPickup,
    super.selectedDropoff,
    super.savedTrips,
    super.routeSuggestions,
  });
}

class CreateTripLoaded extends CreateTripState {
  final LocationFieldType lastModifiedField;

  CreateTripLoaded({
    super.pickupResults,
    super.dropoffResults,
    super.selectedPickup,
    super.selectedDropoff,
    super.savedTrips,
    super.routeSuggestions,
    required this.lastModifiedField,
  });
}

class CreateTripError extends CreateTripState {
  final String message;
  CreateTripError(this.message);
}

/// ================= BLOC =================
class CreateTripBloc extends Bloc<CreateTripEvent, CreateTripState> {
  final SearchLocationUseCase searchUseCase;
  Timer? _debounce;

  CreateTripBloc({required this.searchUseCase}) : super(CreateTripInitial()) {

    // 1. XỬ LÝ TÌM KIẾM (DEBOUNCE)
    on<SearchQueryChanged>((event, emit) {
      _debounce?.cancel();
      if (event.query.isEmpty) {
        emit(CreateTripLoaded(
          pickupResults: const [],
          dropoffResults: const [],
          selectedPickup: state.selectedPickup,
          selectedDropoff: state.selectedDropoff,
          savedTrips: state.savedTrips,
          lastModifiedField: event.fieldType,
          routeSuggestions: state.routeSuggestions,
        ));
        return;
      }
      _debounce = Timer(const Duration(milliseconds: 600), () {
        add(_FetchLocationsInternal(event.query, event.fieldType));
      });
    });

    // 2. GỌI API TÌM ĐỊA CHỈ
    on<_FetchLocationsInternal>((event, emit) async {
      emit(CreateTripLoading(
        pickupResults: state.pickupResults,
        dropoffResults: state.dropoffResults,
        selectedPickup: state.selectedPickup,
        selectedDropoff: state.selectedDropoff,
        savedTrips: state.savedTrips,
        routeSuggestions: state.routeSuggestions,
      ));

      final result = await searchUseCase(event.query);

      result.fold(
            (failure) => emit(CreateTripError("Lỗi kết nối bản đồ")),
            (results) {
          emit(CreateTripLoaded(
            pickupResults: event.fieldType == LocationFieldType.pickup ? results : state.pickupResults,
            dropoffResults: event.fieldType == LocationFieldType.dropoff ? results : state.dropoffResults,
            selectedPickup: state.selectedPickup,
            selectedDropoff: state.selectedDropoff,
            savedTrips: state.savedTrips,
            lastModifiedField: event.fieldType,
            routeSuggestions: state.routeSuggestions,
          ));
        },
      );
    });

    // 3. XỬ LÝ CHỌN ĐỊA ĐIỂM + GỌI API LẤY ĐƯỜNG THẬT
    on<SelectLocationEvent>((event, emit) async {
      CreateTripLocationEntity? currentPickup = state.selectedPickup;
      CreateTripLocationEntity? currentDropoff = state.selectedDropoff;

      if (event.fieldType == LocationFieldType.pickup) {
        currentPickup = event.location;
      } else {
        currentDropoff = event.location;
      }

      List<TripRouteEntity> apiSuggestions = [];

      // Chỉ gọi API khi đủ 2 điểm
      if (currentPickup != null && currentDropoff != null) {
        try {
          final String token = ApiConstants.mapboxToken;
          //String token = 'pk.eyJ1IjoibWluaHF1YW4xMjMiLCJhIjoiY203eG50NjBvMGFlODJycHY3N3B4M2FyayJ9.O3pW0G6iGOfWpM514O6jMw';
          final url = 'https://api.mapbox.com/directions/v5/mapbox/driving/'
              '${currentPickup.longitude},${currentPickup.latitude};'
              '${currentDropoff.longitude},${currentDropoff.latitude}'
              '?steps=true&access_token=$token';

          final response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final List steps = data['routes'][0]['legs'][0]['steps'];

            List<String> realStreets = steps
                .map((s) => s['name'].toString())
                .where((name) => name.isNotEmpty && name != "null" && !name.contains("unnamed"))
                .toSet()
                .toList();

            apiSuggestions = [
              TripRouteEntity(
                startLocation: currentPickup.name,
                endLocation: currentDropoff.name,
                waypoints: realStreets.length > 2 ? realStreets.sublist(0, 3) : realStreets,
                rating: 4.8,
              ),
            ];
          }
        } catch (e) {
          print("DEBUG: Lỗi gọi lộ trình thật: $e");
        }
      }

      emit(CreateTripLoaded(
        pickupResults: const [],
        dropoffResults: const [],
        selectedPickup: currentPickup,
        selectedDropoff: currentDropoff,
        savedTrips: state.savedTrips,
        lastModifiedField: event.fieldType,
        routeSuggestions: apiSuggestions,
      ));
    });

    // 4. LƯU CHUYẾN ĐI
    on<AddSavedTripEvent>((event, emit) {
      final updatedSavedList = List<SavedTripEntity>.from(state.savedTrips)..add(event.trip);

      emit(CreateTripLoaded(
        pickupResults: const [],
        dropoffResults: const [],
        selectedPickup: state.selectedPickup,
        selectedDropoff: state.selectedDropoff,
        savedTrips: updatedSavedList,
        lastModifiedField: LocationFieldType.pickup,
        routeSuggestions: state.routeSuggestions,
      ));
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}