import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/profile_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm dòng này

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRemoteDataSource authRemoteDataSource;

  ProfileBloc({required this.authRemoteDataSource}) : super(ProfileInitial()) {
    on<GetProfileRequested>((event, emit) async {
      emit(ProfileLoading());

      try {
        // 1. Gọi API lấy dữ liệu (trả về UserModel)
        final response = await authRemoteDataSource.getProfile();

        // 2. TRÍCH XUẤT DỮ LIỆU SANG MAP (Cách an toàn nhất)
        // Thay vì jsonEncode (dễ lỗi nếu UserModel ko có toJson),
        // ta dùng dynamic để lấy dữ liệu từ các field mà Java Backend đã trả về.
        final dynamic rawData = response;

        final Map<String, dynamic> jsonData = {
          'fullName': _getProperty(rawData, 'fullName'),
          'email': _getProperty(rawData, 'email'),
          'avatarUrl': _getProperty(rawData, 'avatarUrl'),
          'identifier': _getProperty(rawData, 'identifier'),
        };

        // 3. KHỞI TẠO BẰNG PROFILE MODEL
        final profile = ProfileModel.fromJson(jsonData);

        emit(ProfileLoadSuccess(profile));
      } catch (e) {
        emit(ProfileLoadFailure("Lỗi xử lý Profile: ${e.toString()}"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        // 1. Xóa token trong SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');

        // Bạn có thể xóa thêm các thông tin khác nếu cần như:
        // await prefs.clear();

        // 2. Phát ra trạng thái ban đầu hoặc một trạng thái logout thành công
        emit(ProfileInitial());
      } catch (e) {
        emit(ProfileLoadFailure("Không thể đăng xuất: ${e.toString()}"));
      }
    });
  }

  // Hàm bổ trợ lấy giá trị từ đối tượng dynamic để tránh crash
  dynamic _getProperty(dynamic object, String key) {
    try {
      // Thử lấy qua hàm toJson() nếu có
      return object.toJson()[key];
    } catch (_) {
      try {
        // Nếu không, thử truy cập trực tiếp bằng dynamic member
        if (key == 'fullName') return object.fullName;
        if (key == 'email') return object.email;
        if (key == 'avatarUrl') return object.avatarUrl;
        if (key == 'identifier') return object.identifier;
      } catch (_) {
        return null;
      }
    }
    return null;
  }


}