import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/core/failure.dart';
import 'user.dart' as user_model;

abstract class AuthRepositoryProtocol {
  Future<Either<Failure, bool>> register(
      {required String email, required String password});
  Future<Either<Failure, user_model.User>> login(
      {required String email, required String password});
  Future<Either<Failure, bool>> addUser({required user_model.User user});
  Future<Either<Failure, user_model.User>> getUser();
  Future<Either<Failure, bool>> logout();
}

class AuthRepository extends AuthRepositoryProtocol {
  final FirebaseAuth firebaseAuth;
  final SharedPreferences sharedPreferences;
  AuthRepository({
    required this.firebaseAuth,
    required this.sharedPreferences,
  });
  static const key = "USER_KEY";

  @override
  Future<Either<Failure, bool>> register(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firebaseAuth.signOut();
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(errorMessage: "Authentication Error ${e.code}"));
    } catch (e) {
      return Left(Failure(errorMessage: "Generic Error ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, user_model.User>> login(
      {required String email, required String password}) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return Left(Failure(errorMessage: "Authentication Error Fail Login"));
      }
      return Right(user_model.User(email: response.user?.email ?? ""));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(errorMessage: "Authentication Error ${e.code}"));
    } catch (e) {
      return Left(Failure(errorMessage: "Generic Error ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> addUser({required user_model.User user}) async {
    try {
      final request = await sharedPreferences.setString(key, user.toJson());
      if (!request) Left(Failure(errorMessage: "Generic Error Fail To Save"));
      return const Right(true);
    } catch (e) {
      return Left(Failure(errorMessage: "Generic Error ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, user_model.User>> getUser() async {
    try {
      final result = sharedPreferences.getString(key) ?? "";
      if (result.isEmpty) {
        return Left(Failure(errorMessage: "Fail Get User Data"));
      }
      return Right(user_model.User.fromJson(result));
    } catch (e) {
      return Left(Failure(errorMessage: "Generic Error ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await firebaseAuth.signOut();
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(errorMessage: "Authentication Error ${e.code}"));
    } catch (e) {
      return Left(Failure(errorMessage: "Generic Error ${e.toString()}"));
    }
  }
}
