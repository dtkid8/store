import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
  final FlutterSecureStorage secureStorage;
  AuthRepository({
    required this.firebaseAuth,
    required this.secureStorage,
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
    } on FirebaseAuthException catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return Left(Failure(errorMessage: "Authentication Error ${e.code}"));
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return Left(Failure(errorMessage: "General Error ${e.toString()}"));
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
    } on FirebaseAuthException catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return Left(Failure(errorMessage: "Authentication Error ${e.code}"));
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return Left(Failure(errorMessage: "General Error ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> addUser({required user_model.User user}) async {
    try {
      await secureStorage.write(key: key, value: user.toJson());
      return const Right(true);
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return Left(Failure(errorMessage: "General Error ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, user_model.User>> getUser() async {
    try {
      final result = await secureStorage.read(key: key) ?? "";
      if (result.isEmpty) {
        return Left(Failure(errorMessage: "Fail Get User Data"));
      }
      return Right(user_model.User.fromJson(result));
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return Left(Failure(errorMessage: "General Error ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await secureStorage.delete(key: key);
      await firebaseAuth.signOut();
      return const Right(true);
    } on FirebaseAuthException catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return Left(Failure(errorMessage: "Authentication Error ${e.code}"));
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      return Left(Failure(errorMessage: "General Error ${e.toString()}"));
    }
  }
}
