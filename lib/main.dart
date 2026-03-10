// lib/main.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// 1. Core & Theme
import 'core/theme/app_colors.dart';

// 2. Pages
import 'features/register_driver/presentation/pages/register_driver_page.dart';
import 'features/create_trip/presentation/pages/create_trip_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/intro_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/home_driver/presentation/pages/home_driver_page.dart';
import 'features/auth/presentation/pages/intro1_page.dart';

// 3. Logic & Data (Auth)
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/profile_bloc.dart';

// 4. Logic & Data (Create Trip)
import 'features/create_trip/data/datasources/create_trip_remote_datasource.dart';
import 'features/create_trip/data/repository/create_trip_repository_impl.dart';
import 'features/create_trip/presentation/bloc/create_trip_bloc.dart';
import 'features/create_trip/domain/usecase/search_location_usecase.dart';

// 5. Logic & Data (Register Driver)
import 'features/register_driver/data/datasources/driver_remote_data_source.dart';
import 'features/register_driver/data/repositories/driver_repository_impl.dart';
import 'features/register_driver/domain/usecases/register_driver_usecase.dart';
import 'features/register_driver/presentation/bloc/register_driver_bloc.dart';
import 'features/register_driver/data/datasources/driver_local_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  await _initializeFirebase();

  // --- Khởi tạo chung ---
  final httpClient = http.Client();
  final dio = Dio();

  // --- Khởi tạo Auth ---
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  // --- Khởi tạo Create Trip ---
  final createTripRemoteDataSource = CreateTripRemoteDataSourceImpl(dio: dio);
  final createTripRepository = CreateTripRepositoryImpl(
    remoteDataSource: createTripRemoteDataSource,
  );
  final searchLocationUseCase = SearchLocationUseCase(createTripRepository);

  // --- Khởi tạo Register Driver & Local Data ---
  final driverRemoteDataSource = DriverRemoteDataSourceImpl(client: httpClient);
  final driverLocalDataSource = DriverLocalDataSourceImpl(sharedPreferences: sharedPreferences);

  final driverRepository = DriverRepositoryImpl(
    remoteDataSource: driverRemoteDataSource,
    localDataSource: driverLocalDataSource, // Đã thêm local vào repo
  );
  final registerDriverUseCase = RegisterDriverUsecase(driverRepository);

  // --- KIỂM TRA TRẠNG THÁI DRIVER ---
  // Nếu key CACHED_VEHICLE_ID tồn tại thì coi như đã là Driver
  final bool isDriver = driverLocalDataSource.isDriver();

  runApp(MyApp(
    searchLocationUseCase: searchLocationUseCase,
    authRemoteDataSource: authRemoteDataSource,
    registerDriverUseCase: registerDriverUseCase,
    isDriver: isDriver,
  ));
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    messaging.getToken().then((token) => debugPrint("FCM TOKEN: $token"));
  } catch (e) {
    debugPrint("Lỗi khởi tạo Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  final SearchLocationUseCase searchLocationUseCase;
  final AuthRemoteDataSource authRemoteDataSource;
  final RegisterDriverUsecase registerDriverUseCase;
  final bool isDriver;

  const MyApp({
    super.key,
    required this.searchLocationUseCase,
    required this.authRemoteDataSource,
    required this.registerDriverUseCase,
    required this.isDriver,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateTripBloc(searchUseCase: searchLocationUseCase),
        ),
        BlocProvider(
          create: (context) => AuthBloc(authRemoteDataSource: authRemoteDataSource)..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(authRemoteDataSource: authRemoteDataSource),
        ),
        BlocProvider(
          create: (context) => RegisterDriverBloc(registerDriverUsecase: registerDriverUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'DHAY Driver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Poppins',
        ),
        // LOGIC ĐIỀU HƯỚNG:
        // Nếu là Driver thì vào thẳng Home Driver, ngược lại vào Intro
        initialRoute: '/intro',

        routes: {
          '/intro': (context) => const IntroPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/intro1': (context) => const Intro1Page(),
          '/home_driver': (context) => const HomeDriverPage(),
          '/register_driver': (context) => const DriverRegisterPage(),
          '/create_trip': (context) => const CreateTripPage(),
        },
      ),
    );
  }
}