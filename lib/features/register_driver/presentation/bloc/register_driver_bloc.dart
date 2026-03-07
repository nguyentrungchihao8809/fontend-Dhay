import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/register_driver_request_model.dart';
import 'register_driver_event.dart';
import 'register_driver_state.dart';

class RegisterDriverBloc extends Bloc<RegisterDriverEvent, RegisterDriverState> {
  RegisterDriverBloc() : super(RegisterDriverInitial()) {
    on<RegisterDriverSubmitted>((event, emit) async {
      emit(RegisterDriverLoading());
      try {
        final request = RegisterDriverRequestModel(
          licenseNumber: event.licenseNumber,
          vehiclePlate: event.vehiclePlate,
          vehicleBrand: event.vehicleBrand,
          vehicleModel: event.vehicleModel,
          capacity: event.capacity,
          vehicleType: event.vehicleType,
        );

        // Log dữ liệu để kiểm tra
        print("Gửi dữ liệu qua Backend: ${request.toJson()}");
        await Future.delayed(const Duration(seconds: 2)); // Giả lập chờ server

        emit(RegisterDriverSuccess());
      } catch (e) {
        emit(RegisterDriverFailure("Lỗi đăng ký: ${e.toString()}"));
      }
    });
  }
}