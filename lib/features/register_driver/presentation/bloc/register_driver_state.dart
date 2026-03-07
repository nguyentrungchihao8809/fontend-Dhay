abstract class RegisterDriverState {}

class RegisterDriverInitial extends RegisterDriverState {}
class RegisterDriverLoading extends RegisterDriverState {}
class RegisterDriverSuccess extends RegisterDriverState {}
class RegisterDriverFailure extends RegisterDriverState {
  final String message;
  RegisterDriverFailure(this.message);
}