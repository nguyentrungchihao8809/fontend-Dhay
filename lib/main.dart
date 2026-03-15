// lib/main.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// 1. Core & Theme
import 'package:ghepxenew/core/theme/app_colors.dart';

// 2. Pages
import 'package:ghepxenew/features/register_driver/presentation/pages/register_driver_page.dart';
import 'package:ghepxenew/features/create_trip/presentation/pages/create_trip_page.dart';
import 'package:ghepxenew/features/auth/presentation/pages/login_page.dart';
import 'package:ghepxenew/features/auth/presentation/pages/intro_page.dart';
import 'package:ghepxenew/features/home/presentation/pages/home_page.dart';
import 'package:ghepxenew/features/home_driver/presentation/pages/home_driver_page.dart';
import 'package:ghepxenew/features/auth/presentation/pages/intro1_page.dart';
import 'package:ghepxenew/features/payment/presentation/pages/payment_page.dart';
// THÊM: Trang Hóa Đơn
import 'package:ghepxenew/features/trip_invoice/presentation/pages/trip_invoice_page.dart';

// 3. Logic & Data (Auth)
import 'package:ghepxenew/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ghepxenew/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ghepxenew/features/auth/presentation/bloc/profile_bloc.dart';

// 4. Logic & Data (Create Trip)
import 'package:ghepxenew/features/create_trip/data/datasources/create_trip_remote_datasource.dart';
import 'package:ghepxenew/features/create_trip/data/repository/create_trip_repository_impl.dart';
import 'package:ghepxenew/features/create_trip/presentation/bloc/create_trip_bloc.dart';
import 'package:ghepxenew/features/create_trip/domain/usecase/search_location_usecase.dart';

// 5. Logic & Data (Register Driver)
import 'package:ghepxenew/features/register_driver/data/datasources/driver_remote_data_source.dart';
import 'package:ghepxenew/features/register_driver/data/repositories/driver_repository_impl.dart';
import 'package:ghepxenew/features/register_driver/domain/usecases/register_driver_usecase.dart';
import 'package:ghepxenew/features/register_driver/presentation/bloc/register_driver_bloc.dart';
import 'package:ghepxenew/features/register_driver/data/datasources/driver_local_data_source.dart';

// 6. Logic & Data (Payment)
import 'package:ghepxenew/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:ghepxenew/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:ghepxenew/features/payment/domain/usecases/get_payment_methods.dart';
import 'package:ghepxenew/features/payment/domain/usecases/process_payment.dart';
import 'package:ghepxenew/features/payment/presentation/bloc/payment_bloc.dart';

// 7. Logic & Data (Trip Invoice) - MỚI TÍCH HỢP
import 'package:ghepxenew/features/trip_invoice/data/datasources/invoice_remote_data_source.dart';
import 'package:ghepxenew/features/trip_invoice/data/repositories/invoice_repository_impl.dart';
import 'package:ghepxenew/features/trip_invoice/domain/usecases/get_invoice_details.dart';
import 'package:ghepxenew/features/trip_invoice/presentation/bloc/invoice_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  await _initializeFirebase();

  // --- Khởi tạo chung (HttpClient & Dio) ---
  final httpClient = http.Client();
  final dio = Dio();

  // --- 1. Khởi tạo Auth ---
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  // --- 2. Khởi tạo Create Trip ---
  final createTripRemoteDataSource = CreateTripRemoteDataSourceImpl(dio: dio);
  final createTripRepository = CreateTripRepositoryImpl(
    remoteDataSource: createTripRemoteDataSource,
  );
  final searchLocationUseCase = SearchLocationUseCase(createTripRepository);

  // --- 3. Khởi tạo Register Driver & Local Data ---
  final driverRemoteDataSource = DriverRemoteDataSourceImpl(client: httpClient);
  final driverLocalDataSource = DriverLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final driverRepository = DriverRepositoryImpl(
    remoteDataSource: driverRemoteDataSource,
    localDataSource: driverLocalDataSource,
  );
  final registerDriverUseCase = RegisterDriverUsecase(driverRepository);

  // --- 4. Khởi tạo Payment ---
  final paymentRemoteDataSource = PaymentRemoteDataSourceImpl(dio: dio);
  final paymentRepository = PaymentRepositoryImpl(remoteDataSource: paymentRemoteDataSource);
  final getPaymentMethodsUseCase = GetPaymentMethods(paymentRepository);
  final processPaymentUseCase = ProcessPayment(paymentRepository);

  // --- 5. Khởi tạo Trip Invoice (Feature mới) ---
  final invoiceRemoteDataSource = InvoiceRemoteDataSourceImpl(dio: dio);
  final invoiceRepository = InvoiceRepositoryImpl(remoteDataSource: invoiceRemoteDataSource);
  final getInvoiceDetailsUseCase = GetInvoiceDetails(invoiceRepository);

  // Kiểm tra trạng thái Driver từ Local Storage
  final bool isDriver = driverLocalDataSource.isDriver();

  runApp(MyApp(
    searchLocationUseCase: searchLocationUseCase,
    authRemoteDataSource: authRemoteDataSource,
    registerDriverUseCase: registerDriverUseCase,
    getPaymentMethodsUseCase: getPaymentMethodsUseCase,
    processPaymentUseCase: processPaymentUseCase,
    getInvoiceDetailsUseCase: getInvoiceDetailsUseCase, // Truyền vào MyApp
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
  final GetPaymentMethods getPaymentMethodsUseCase;
  final ProcessPayment processPaymentUseCase;
  final GetInvoiceDetails getInvoiceDetailsUseCase; // UseCase hóa đơn
  final bool isDriver;

  const MyApp({
    super.key,
    required this.searchLocationUseCase,
    required this.authRemoteDataSource,
    required this.registerDriverUseCase,
    required this.getPaymentMethodsUseCase,
    required this.processPaymentUseCase,
    required this.getInvoiceDetailsUseCase,
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
          create: (context) => AuthBloc(authRemoteDataSource: authRemoteDataSource),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(authRemoteDataSource: authRemoteDataSource),
        ),
        BlocProvider(
          create: (context) => RegisterDriverBloc(registerDriverUsecase: registerDriverUseCase),
        ),
        BlocProvider(
          create: (context) => PaymentBloc(
            getPaymentMethods: getPaymentMethodsUseCase,
            processPayment: processPaymentUseCase,
          ),
        ),
        // ĐĂNG KÝ INVOICE BLOC TẠI ĐÂY
        BlocProvider(
          create: (context) => InvoiceBloc(getInvoiceDetails: getInvoiceDetailsUseCase),
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

        // Đặt mặc định vào trang hóa đơn để kiểm tra (có thể đổi lại thành /payment hoặc /home)
        initialRoute: '/trip_invoice',

        routes: {
          '/intro': (context) => const IntroPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/intro1': (context) => const Intro1Page(),
          '/home_driver': (context) => const HomeDriverPage(),
          '/register_driver': (context) => const DriverRegisterPage(),
          '/create_trip': (context) => const CreateTripPage(),
          '/payment': (context) => const PaymentPage(),
          '/trip_invoice': (context) => const TripInvoicePage(), // Route hóa đơn
        },
      ),
    );
  }
}