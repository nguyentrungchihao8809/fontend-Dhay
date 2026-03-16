import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/create_trip_location_entity.dart';
import '../../domain/entity/saved_trip_entity.dart'; // THÊM DÒNG NÀY (Nhớ tạo file này trước nhé)
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

// --- THÊM EVENT LƯU CHUYẾN ĐI (Dùng cho Ảnh 4 -> Ảnh 3) ---
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
  final List<SavedTripEntity> savedTrips; // BIẾN LƯU TRỮ DANH SÁCH ĐÃ LƯU

  CreateTripState({
    this.pickupResults = const [],
    this.dropoffResults = const [],
    this.selectedPickup,
    this.selectedDropoff,
    this.savedTrips = const [], // KHỞI TẠO DANH SÁCH RỖNG
  });
}

class CreateTripInitial extends CreateTripState {
  CreateTripInitial({super.savedTrips}); // Giữ lại danh sách khi reset
}

class CreateTripLoading extends CreateTripState {
  CreateTripLoading({
    super.pickupResults,
    super.dropoffResults,
    super.selectedPickup,
    super.selectedDropoff,
    super.savedTrips,
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
        // Luôn truyền state.savedTrips để không bị mất dữ liệu đã lưu
        emit(CreateTripInitial(savedTrips: state.savedTrips));
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
        savedTrips: state.savedTrips,
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
          ));
        },
      );
    });

    // 3. Xử lý khi chọn một địa điểm
    on<SelectLocationEvent>((event, emit) {
      emit(CreateTripLoaded(
        pickupResults: const [],
        dropoffResults: const [],
        selectedPickup: event.fieldType == LocationFieldType.pickup ? event.location : state.selectedPickup,
        selectedDropoff: event.fieldType == LocationFieldType.dropoff ? event.location : state.selectedDropoff,
        savedTrips: state.savedTrips,
        lastModifiedField: event.fieldType,
      ));
    });

    // 4. XỬ LÝ LƯU CHUYẾN ĐI (LOGIC MỚI CHO ẢNH 3)
    on<AddSavedTripEvent>((event, emit) {
      // Lấy danh sách hiện tại và thêm chuyến mới vào
      final updatedSavedList = List<SavedTripEntity>.from(state.savedTrips)..add(event.trip);

      // Cập nhật state Loaded với danh sách mới mà vẫn giữ nguyên các điểm đang chọn trên form
      emit(CreateTripLoaded(
        pickupResults: state.pickupResults,
        dropoffResults: state.dropoffResults,
        selectedPickup: state.selectedPickup,
        selectedDropoff: state.selectedDropoff,
        savedTrips: updatedSavedList, // Cập nhật kho dữ liệu
        lastModifiedField: LocationFieldType.pickup,
      ));

      print("--- Đã lưu thành công chuyến: ${event.trip.name} ---");
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}