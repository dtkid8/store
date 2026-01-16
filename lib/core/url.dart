import 'package:store/core/env.dart';

class Url {
  static String get baseUrl => Env.baseUrl;
  static String get product => "$baseUrl/products";
  static String get category => "$baseUrl/categories";
}
