import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/core/firebase_options.dart';
import 'package:store/features/auth/auth_cubit.dart';
import 'package:store/features/auth/auth_repository.dart';
import 'package:store/features/cart/cart.dart';
import 'package:store/features/cart/cart_repository.dart';
import 'package:store/features/category/category_repository.dart';
import 'package:store/features/product/detail/product_detail_page.dart';
import 'package:store/features/product/product_page.dart';
import 'package:store/features/product/product_repository.dart';
import 'package:store/features/product/search/product_search_page.dart';
import 'package:store/features/splash_page.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';
import 'features/product/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Box<Cart> cartBox = await Hive.openBox<Cart>('cartBox');
  final CartRepository cartRepository = CartRepository(cartBox);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final Dio client = Dio();
  final AuthRepository authRepository = AuthRepository(
      firebaseAuth: firebaseAuth, sharedPreferences: sharedPreferences);
  final ProductRepository productRepository = ProductRepository(client: client);
  final CategoryRepository categoryRepository =
      CategoryRepository(client: client);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => authRepository,
        ),
        RepositoryProvider(
          create: (context) => productRepository,
        ),
        RepositoryProvider(
          create: (context) => categoryRepository,
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(primary: Colors.white),
        fontFamily: 'Montserrat',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.blueGrey;
              }
              return Colors.black;
            }),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            elevation: MaterialStateProperty.all<double>(5),
          ),
        ),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 16.0),
            bodyMedium: TextStyle(fontSize: 14.0),
            bodySmall: TextStyle(fontSize: 12.0),
            titleLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            titleSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            labelSmall: TextStyle(fontSize: 12)),
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
        '/': (context) => const SplashPage(),
        '/product': (context) => const ProductPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/productDetail': (context) => ProductDetailPage(
            product: ModalRoute.of(context)!.settings.arguments as Product),
        '/search': (context) => const ProductSearchPage(),
      },
      title: 'Store',
    );
  }
}
