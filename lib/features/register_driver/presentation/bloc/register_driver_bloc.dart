import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/register_driver_usecase.dart';
import 'register_driver_event.dart';
import 'register_driver_state.dart';

class RegisterDriverBloc extends Bloc<RegisterDriverEvent, RegisterDriverState> {
  final RegisterDriverUsecase registerDriverUsecase;

  RegisterDriverBloc({required this.registerDriverUsecase}) : super(RegisterDriverInitial()) {
    on<OnRegisterSubmit>((event, emit) async {
      emit(RegisterDriverLoading());

      final result = await registerDriverUsecase(event.registration);

      result.fold(
            (failure) => emit(RegisterDriverFailure(failure.message)),
            (vehicleId) => emit(RegisterDriverSuccess(
            vehicleId: vehicleId,
            message: "Đăng ký trở thành tài xế thành công! Vui lòng chờ phê duyệt."
        )),
      );
    });
  }
}