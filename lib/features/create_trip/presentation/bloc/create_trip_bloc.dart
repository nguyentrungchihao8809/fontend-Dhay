import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/create_trip_location_entity.dart';
import '../../domain/usecase/search_location_usecase.dart';

/// ================= ENUM =================
enum LocationFieldType { pickup, dropoff }

/// ================= EVENTS =================
abstract class CreateTripEvent {}

// Sự kiện khi User gõ phím
class SearchQueryChanged extends CreateTripEvent {
  final String query;
  final LocationFieldType fieldType;
  SearchQueryChanged(this.query, this.fieldType);
}

// Sự kiện nội bộ để xử lý Debounce
class _FetchLocationsInternal extends CreateTripEvent {
  final String query;
  final LocationFieldType fieldType;
  _FetchLocationsInternal(this.query, this.fieldType);
}

// Sự kiện khi User nhấn chọn 1 địa chỉ từ danh sách
class SelectLocationEvent extends CreateTripEvent {
  final CreateTripLocationEntity location;
  final LocationFieldType fieldType;
  SelectLocationEvent(this.location, this.fieldType);
}

/// ================= STATES =================
abstract class CreateTripState {
  // Để thuận tiện cho UI, ta đưa các biến dùng chung lên lớp cha
  final List<CreateTripLocationEntity> pickupResults;
  final List<CreateTripLocationEntity> dropoffResults;
  final CreateTripLocationEntity? selectedPickup;
  final CreateTripLocationEntity? selectedDropoff;

  CreateTripState({
    this.pickupResults = const [],
    this.dropoffResults = const [],
    this.selectedPickup,
    this.selectedDropoff,
  });
}

class CreateTripInitial extends CreateTripState {}

class CreateTripLoading extends CreateTripState {
  CreateTripLoading({
    super.pickupResults,
    super.dropoffResults,
    super.selectedPickup,
    super.selectedDropoff,
  });
}

class CreateTripLoaded extends CreateTripState {
  final LocationFieldType lastModifiedField;

  CreateTripLoaded({
    super.pickupResults,
    super.dropoffResults,
    super.selectedPickup,
    super.selectedDropoff,
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

    // 1. Xử lý khi User nhập văn bản
    on<SearchQueryChanged>((event, emit) {
      _debounce?.cancel();
      if (event.query.isEmpty) {
        // Nếu xóa trắng thì quay về Initial nhưng vẫn giữ các điểm đã chọn trước đó
        emit(CreateTripInitial());
        return;
      }
      _debounce = Timer(const Duration(milliseconds: 600), () {
        add(_FetchLocationsInternal(event.query, event.fieldType));
      });
    });

    // 2. Xử lý gọi API Mapbox
    on<_FetchLocationsInternal>((event, emit) async {
      emit(CreateTripLoading(
        pickupResults: state.pickupResults,
        dropoffResults: state.dropoffResults,
        selectedPickup: state.selectedPickup,
        selectedDropoff: state.selectedDropoff,
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
            lastModifiedField: event.fieldType,
          ));
        },
      );
    });

    // 3. Xử lý khi chọn một địa điểm
    on<SelectLocationEvent>((event, emit) {
      // Khi chọn xong, ta xóa danh sách gợi ý (để ẩn ListView) và lưu điểm đã chọn
      emit(CreateTripLoaded(
        pickupResults: const [], // Xóa list gợi ý để UI biết đường mà ẩn đi
        dropoffResults: const [], // Xóa list gợi ý
        selectedPickup: event.fieldType == LocationFieldType.pickup ? event.location : state.selectedPickup,
        selectedDropoff: event.fieldType == LocationFieldType.dropoff ? event.location : state.selectedDropoff,
        lastModifiedField: event.fieldType,
      ));

      print("Đã chọn địa điểm cho ${event.fieldType}: ${event.location.name}");
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}