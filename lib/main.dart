import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/core/firebase_options.dart';
import 'package:store/features/auth/auth_cubit.dart';
import 'package:store/features/auth/auth_repository.dart';
import 'package:store/features/product/detail/product_detail_page.dart';
import 'package:store/features/product/product_page.dart';
import 'package:store/features/product/product_repository.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';
import 'features/product/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final Dio client = Dio();
  final AuthRepository authRepository = AuthRepository(
      firebaseAuth: firebaseAuth, sharedPreferences: sharedPreferences);
  final ProductRepository productRepository = ProductRepository(client: client);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => authRepository,
        ),
        RepositoryProvider(
          create: (context) => productRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthCubit(repository: authRepository),
        child: const StoreApp(),
      ),
    ),
  );
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 14.0),
          titleLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      routes: {
        '/': (context) => const ProductPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/productDetail': (context) => ProductDetailPage(
            product: ModalRoute.of(context)!.settings.arguments as Product),
      },
      title: 'Store',
    );
  }
}
