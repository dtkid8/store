import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/core/firebase_options.dart';
import 'package:store/features/auth/auth_cubit.dart';
import 'package:store/features/auth/auth_repository.dart';
import 'package:store/features/product/product_page.dart';

import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final AuthRepository authRepository = AuthRepository(
      firebaseAuth: firebaseAuth, sharedPreferences: sharedPreferences);

  runApp(
    RepositoryProvider(
      create: (context) => authRepository,
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
      routes: {
        '/': (context) => const ProductPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      title: 'Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
