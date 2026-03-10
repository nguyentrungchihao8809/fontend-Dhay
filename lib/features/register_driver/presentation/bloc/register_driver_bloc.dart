import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/register_driver_usecase.dart';
import '../../domain/usecases/check_driver_status_usecase.dart'; // Đảm bảo import này đúng
import 'register_driver_event.dart';
import 'register_driver_state.dart';

class RegisterDriverBloc extends Bloc<RegisterDriverEvent, RegisterDriverState> {
  final RegisterDriverUsecase registerDriverUsecase;
  final CheckDriverStatusUseCase checkDriverStatusUseCase; // Thêm usecase check status

  RegisterDriverBloc({
    required this.registerDriverUsecase,
    required this.checkDriverStatusUseCase,
  }) : super(RegisterDriverInitial()) {

    // 1. Xử lý sự kiện Đăng ký tài xế (Submit Form)
    on<OnRegisterSubmit>((event, emit) async {
      print("🚀 Bloc nhận được sự kiện đăng ký: ${event.registration.vehiclePlate}");
      emit(RegisterDriverLoading());

      try {
        final result = await registerDriverUsecase(event.registration);

        result.fold(
              (failure) => emit(RegisterDriverFailure(failure.message)),
              (vehicleId) => emit(RegisterDriverSuccess(
              vehicleId: vehicleId,
              message: "Đăng ký trở thành tài xế thành công! Vui lòng chờ phê duyệt."
          )),
        );
      } catch (e) {
        print("🚨 Lỗi tại Bloc (Register): $e");
        emit(RegisterDriverFailure("Đã xảy ra lỗi: ${e.toString()}"));
      }
    });

    // 2. Xử lý sự kiện Kiểm tra trạng thái tài xế (Check Status)
    on<OnCheckDriverStatus>((event, emit) async {
      print("📡 Bloc đang kiểm tra trạng thái tài xế...");
      emit(RegisterDriverLoading());

      try {
        final result = await checkDriverStatusUseCase();

        result.fold(
              (failure) => emit(RegisterDriverFailure(failure.message)),
              (isRegistered) => emit(DriverStatusResult(isRegistered)),
        );
      } catch (e) {
        print("🚨 Lỗi tại Bloc (CheckStatus): $e");
        emit(RegisterDriverFailure("Không thể kiểm tra trạng thái tài xế."));
      }
    });
  }
}