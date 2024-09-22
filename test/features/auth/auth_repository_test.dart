import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store/features/auth/auth_repository.dart';
import 'package:store/features/auth/user.dart' as user_model;

import '../../mock.dart';

void main() {
  late AuthRepository repository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockSharedPreferences mockSharedPreferences;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockSharedPreferences = MockSharedPreferences();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    repository = AuthRepository(
      firebaseAuth: mockFirebaseAuth,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('AuthRepository', () {
    const String testEmail = 'test@example.com';
    const String testPassword = 'testPassword';
    user_model.User testUser = user_model.User(email: testEmail);

    test('register returns true when successful', () async {
      // Arrange
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Act
      final result =
          await repository.register(email: testEmail, password: testPassword);

      // Assert
      expect(result, const Right(true));
      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          )).called(1);
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('register returns Failure on FirebaseAuthException', () async {
      // Arrange
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      // Act
      final result =
          await repository.register(email: testEmail, password: testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(
            failure.errorMessage, 'Authentication Error email-already-in-use'),
        (r) => fail('Expected a failure but got success'),
      );
    });

    test('login returns user when successful', () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn(testEmail);

      // Act
      final result =
          await repository.login(email: testEmail, password: testPassword);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success, got failure'),
        (user) => expect(user.email, testEmail),
      );
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: testEmail, password: testPassword),
      ).called(1);
    });

    test('login returns Failure when FirebaseAuthException occurs', () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      // Act
      final result =
          await repository.login(email: testEmail, password: testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.errorMessage, 'Authentication Error wrong-password'),
        (_) => fail('Expected failure, got success'),
      );
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: testEmail, password: testPassword),
      ).called(1);
    });

    test('addUser returns true when successful', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(
            AuthRepository.key,
            any(),
          )).thenAnswer((_) async => true);

      // Act
      final result = await repository.addUser(user: testUser);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockSharedPreferences.setString(
            AuthRepository.key,
            testUser.toJson(),
          )).called(1);
    });

    test('addUser returns Failure when saving fails', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(
            AuthRepository.key,
            testUser.toJson(),
          )).thenAnswer((_) async => false);

      // Act
      final result = await repository.addUser(user: testUser);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.errorMessage, 'General Error Fail To Save'),
        (_) => fail('Expected failure, got success'),
      );
    });

    test('getUser returns user when successful', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AuthRepository.key))
          .thenReturn(testUser.toJson());

      // Act
      final result = await repository.getUser();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success, got failure'),
        (user) => expect(user.email, testEmail),
      );
    });

    test('getUser returns Failure when no user is found', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AuthRepository.key))
          .thenReturn(null);

      // Act
      final result = await repository.getUser();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.errorMessage, 'Fail Get User Data'),
        (_) => fail('Expected failure, got success'),
      );
    });

    test('logout returns true when successful', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(AuthRepository.key))
          .thenAnswer((_) async => true);
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockSharedPreferences.remove(AuthRepository.key)).called(1);
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('logout returns Failure on FirebaseAuthException', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(AuthRepository.key))
          .thenAnswer((_) async => true);
      when(() => mockFirebaseAuth.signOut())
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.errorMessage, 'Authentication Error user-not-found'),
        (_) => fail('Expected failure, got success'),
      );
    });
  });
}
