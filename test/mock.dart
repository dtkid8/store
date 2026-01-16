import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store/features/auth/auth_repository.dart';
import 'package:store/features/cart/cart.dart';
import 'package:store/features/cart/cart_repository.dart';
import 'package:store/features/category/category_repository.dart';
import 'package:store/features/product/product_repository.dart';

class MockDio extends Mock implements Dio {}

class MockCartBox extends Mock implements Box<Cart> {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCartRepository extends Mock implements CartRepository {}
