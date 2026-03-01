import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

// Import Core & Theme
import 'core/theme/app_colors.dart';

// Import Pages
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/intro_page.dart';
import 'features/place/presentation/pages/place_search_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/home_driver/presentation/pages/home_driver_page.dart'; // Import mới cho Driver
import 'package:ghepxenew/features/auth/presentation/pages/intro1_page.dart';

// Import Logic/Data
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/place/data/datasources/mapbox_place_remote.dart';
import 'features/place/data/repository/place_repository_impl.dart';
import 'features/place/domain/usecase/search_place_usecase.dart';
import 'features/place/presentation/bloc/place_search_placeholder_bloc.dart';
import 'features/auth/presentation/bloc/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();

  final httpClient = http.Client();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  final dio = Dio();
  final remoteDataSource = MapboxPlaceRemoteDataSource(dio: dio);
  final repository = PlaceRepositoryImpl(remoteDataSource: remoteDataSource);
  final searchPlaceUseCase = SearchPlaceUseCase(repository);

  runApp(MyApp(
    searchPlaceUseCase: searchPlaceUseCase,
    authRemoteDataSource: authRemoteDataSource,
  ));
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.requestPermission(alert: true, badge: true, sound: true);
    messaging.getToken().then((token) {
      debugPrint("FCM TOKEN: $token");
    }).catchError((e) => debugPrint("Lỗi lấy FCM Token: $e"));
  } catch (e) {
    debugPrint("Lỗi khởi tạo Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  final SearchPlaceUseCase searchPlaceUseCase;
  final AuthRemoteDataSource authRemoteDataSource;

  const MyApp({
    super.key,
    required this.searchPlaceUseCase,
    required this.authRemoteDataSource,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PlaceSearchBloc(searchPlaceUseCase: searchPlaceUseCase),
        ),
        BlocProvider(
          create: (context) => AuthBloc(authRemoteDataSource: authRemoteDataSource)..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            authRemoteDataSource: authRemoteDataSource,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Ghep Xe App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          // Sử dụng bảng màu AppColors đã dọn dẹp để đồng bộ
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
        ),

        // Đã đổi route khởi đầu sang trang Driver theo ý cưng
        initialRoute: '/home_driver',

        routes: {
          '/intro': (context) => const IntroPage(),
          '/login': (context) => const LoginPage(),
          '/search': (context) => const PlaceSearchPage(),
          '/home': (context) => const HomePage(),
          '/intro1': (context) => const Intro1Page(),
          '/home_driver': (context) => const HomeDriverPage(), // Route cho trang Driver
        },
      ),
    );
  }
}