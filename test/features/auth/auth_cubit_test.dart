import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store/core/failure.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/auth/auth_cubit.dart';
import 'package:store/features/auth/user.dart';

import '../../mock.dart';

late AuthCubit cubit;
late MockAuthRepository repository;
late User user;
const String email = "test@gmail.com";
const String password = "123456";
void main() {
  setUp(() {
    repository = MockAuthRepository();
    cubit = AuthCubit(repository: repository);
    user = User(email: email);
  });

  group("AuthCubit", () {
    test('Initial state should be initialize', () {
      expect(cubit.state, GenericInitializeState());
      expect(cubit.user, User(email: ""));
    });

    blocTest<AuthCubit, GenericState>(
      "Should emit [Loading,Loaded] when login is success",
      build: () {
        when(() => repository.login(email: email, password: password))
            .thenAnswer(
          (_) async => Right(
            user,
          ),
        );
        when(() => repository.addUser(user: user)).thenAnswer(
          (_) async => const Right(
            true,
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.login(password: password, email: email),
      expect: () => [
        GenericLoadingState(),
        GenericLoadedState(
          data: user,
        )
      ],
      verify: (cubit) {
        verify(() => repository.login(email: email, password: password))
            .called(1);
        verify(() => repository.addUser(user: user)).called(1);
        expect(cubit.user, user);
      },
    );

    blocTest<AuthCubit, GenericState>(
      "Should emit [Loading,Error] when login is failed",
      build: () {
        when(() => repository.login(email: email, password: password))
            .thenAnswer(
          (_) async => Left(Failure(errorMessage: "Fail Login")),
        );
        return cubit;
      },
      act: (cubit) => cubit.login(password: password, email: email),
      expect: () => [
        GenericLoadingState(),
        GenericErrorState(errorMessage: "Fail Login")
      ],
      verify: (cubit) {
        verify(() => repository.login(email: email, password: password))
            .called(1);
        expect(cubit.user, User(email: ""));
      },
    );
  });

  blocTest<AuthCubit, GenericState>(
    "Should emit [Loading,Action] when register is success",
    build: () {
      when(() => repository.register(email: email, password: password))
          .thenAnswer(
        (_) async => const Right(
          true,
        ),
      );
      return cubit;
    },
    act: (cubit) => cubit.register(password: password, email: email),
    expect: () => [
      GenericLoadingState(),
      GenericActionLoadedState(message: "Succes Register $email")
    ],
    verify: (cubit) {
      verify(() => repository.register(email: email, password: password))
          .called(1);
      expect(cubit.user, User(email: ""));
    },
  );

  blocTest<AuthCubit, GenericState>(
    "Should emit [Loading,Error] when register is fail",
    build: () {
      when(() => repository.register(email: email, password: password))
          .thenAnswer(
        (_) async => Left(Failure(errorMessage: "Fail To Register")),
      );
      return cubit;
    },
    act: (cubit) => cubit.register(password: password, email: email),
    expect: () => [
      GenericLoadingState(),
      GenericErrorState(errorMessage: "Fail To Register")
    ],
    verify: (cubit) {
      verify(() => repository.register(email: email, password: password))
          .called(1);
      expect(cubit.user, User(email: ""));
    },
  );

  blocTest<AuthCubit, GenericState>(
    "Should emit [Loading,Loaded] when check is success",
    build: () {
      when(() => repository.getUser()).thenAnswer(
        (_) async => Right(user),
      );
      return cubit;
    },
    act: (cubit) => cubit.check(),
    expect: () => [GenericLoadingState(), GenericLoadedState(data: user)],
    verify: (cubit) {
      verify(() => repository.getUser()).called(1);
      expect(cubit.user, user);
    },
  );

  blocTest<AuthCubit, GenericState>(
    "Should emit [Loading,Error,Initialize] when check is fail",
    build: () {
      when(() => repository.getUser()).thenAnswer(
        (_) async => Left(Failure(errorMessage: "Fail Check")),
      );
      return cubit;
    },
    act: (cubit) => cubit.check(),
    expect: () => [
      GenericLoadingState(),
      GenericErrorState(errorMessage: "Fail Check"),
      GenericInitializeState(),
    ],
    verify: (cubit) {
      verify(() => repository.getUser()).called(1);
      expect(cubit.user, User(email: ""));
    },
  );

  blocTest<AuthCubit, GenericState>(
    "Should emit [Loading,Initialize] when logout is success",
    build: () {
      when(() => repository.logout()).thenAnswer(
        (_) async => const Right(true),
      );
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      GenericLoadingState(),
      GenericInitializeState(),
    ],
    verify: (cubit) {
      verify(() => repository.logout()).called(1);
      expect(cubit.user, User(email: ""));
    },
  );

  blocTest<AuthCubit, GenericState>(
    "Should emit [Loading,Error] when logout is fail",
    build: () {
      when(() => repository.logout()).thenAnswer(
        (_) async => Left(Failure(errorMessage: "Fail Logout")),
      );
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      GenericLoadingState(),
      GenericErrorState(errorMessage: 'Fail Logout'),
    ],
    verify: (cubit) {
      verify(() => repository.logout()).called(1);
      expect(cubit.user, User(email: ""));
    },
  );
}
