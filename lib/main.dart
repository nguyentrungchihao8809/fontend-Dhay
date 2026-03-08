import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

// 1. Core & Theme
import 'core/theme/app_colors.dart';

// 2. Pages
import 'features/create_trip/presentation/pages/create_trip_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/intro_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/home_driver/presentation/pages/home_driver_page.dart';
import 'features/auth/presentation/pages/intro1_page.dart';
// Lưu ý: Đổi import này sang folder register_driver mới
import 'features/register_driver/presentation/pages/driver_register_page.dart';

// 3. Logic & Data
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/profile_bloc.dart';

// Create Trip Logic
import 'features/create_trip/data/datasources/create_trip_remote_datasource.dart';
import 'features/create_trip/data/repository/create_trip_repository_impl.dart';
import 'features/create_trip/presentation/bloc/create_trip_bloc.dart';
import 'features/create_trip/domain/usecase/search_location_usecase.dart';

// Register Driver Logic (MỚI THÊM)
import 'features/register_driver/presentation/bloc/register_driver_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();

  // --- Khởi tạo Auth ---
  final httpClient = http.Client();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  // --- Khởi tạo Create Trip ---
  final dio = Dio();
  final createTripRemoteDataSource = CreateTripRemoteDataSourceImpl(dio: dio);
  final createTripRepository = CreateTripRepositoryImpl(
    remoteDataSource: createTripRemoteDataSource,
  );
  final searchLocationUseCase = SearchLocationUseCase(createTripRepository);

  runApp(MyApp(
    searchLocationUseCase: searchLocationUseCase,
    authRemoteDataSource: authRemoteDataSource,
  ));
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    messaging.getToken().then((token) {
      debugPrint("FCM TOKEN: $token");
    });
  } catch (e) {
    debugPrint("Lỗi khởi tạo Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  final SearchLocationUseCase searchLocationUseCase;
  final AuthRemoteDataSource authRemoteDataSource;

  const MyApp({
    super.key,
    required this.searchLocationUseCase,
    required this.authRemoteDataSource,
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
        // ĐĂNG KÝ BLoC ĐĂNG KÝ TÀI XẾ Ở ĐÂY
        BlocProvider(
          create: (context) => RegisterDriverBloc(),
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
        // Bạn đang để khởi đầu là tạo chuyến đi, nếu muốn test đăng ký driver thì đổi sang /register_driver
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