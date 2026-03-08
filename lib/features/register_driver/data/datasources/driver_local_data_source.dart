import 'package:shared_preferences/shared_preferences.dart';

abstract class DriverLocalDataSource {
  Future<void> cacheDriverStatus(String vehicleId);
  bool isDriver();
  String? getCachedVehicleId();
}

class DriverLocalDataSourceImpl implements DriverLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _driverKey = 'CACHED_VEHICLE_ID';

  DriverLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheDriverStatus(String vehicleId) async {
    await sharedPreferences.setString(_driverKey, vehicleId);
  }

  @override
  bool isDriver() {
    return sharedPreferences.getString(_driverKey) != null;
  }

  @override
  String? getCachedVehicleId() {
    return sharedPreferences.getString(_driverKey);
  }
}