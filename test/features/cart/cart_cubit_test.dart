import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store/core/failure.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/cart/cart.dart';
import 'package:store/features/cart/cart_cubit.dart';
import 'package:store/features/product/product.dart';
import 'package:store/features/product/product_response.dart';

import '../../mock.dart';
import '../../response.dart';

void main() {
  late CartCubit cubit;
  late MockCartRepository repository;

  setUp(() {
    repository = MockCartRepository();
    cubit = CartCubit(cartRepository: repository);
  });

  group("CartCubit", () {
    test('Initial state should be initialize', () {
      expect(cubit.state, GenericInitializeState());
      expect(cubit.cart, []);
    });

    final product =
        Product.fromResponse(ProductResponse.fromMap(productResponse));
    final cartItem = Cart(product: product, quantity: 2);

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Loaded] when loadCart is success',
      build: () {
        when(() => repository.getCartItems())
            .thenAnswer((_) async => Right([cartItem]));
        return cubit;
      },
      act: (cubit) => cubit.loadCartItems(),
      expect: () => [
        GenericLoadingState(),
        GenericLoadedState(data: [cartItem]),
      ],
      verify: (_) {
        verify(() => repository.getCartItems()).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Error] when loadCart is fail',
      build: () {
        when(() => repository.getCartItems()).thenAnswer(
            (_) async => Left(Failure(errorMessage: "Fail Load Cart")));
        return cubit;
      },
      act: (cubit) => cubit.loadCartItems(),
      expect: () => [
        GenericLoadingState(),
        GenericErrorState(errorMessage: "Fail Load Cart"),
      ],
      verify: (_) {
        verify(() => repository.getCartItems()).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Loaded] when addItem is success',
      build: () {
        when(() => repository.addItem(product))
            .thenAnswer((_) async => const Right(unit));
        when(() => repository.getCartItems())
            .thenAnswer((_) async => Right([cartItem]));
        return cubit;
      },
      act: (cubit) => cubit.addItem(product),
      expect: () => [
        GenericLoadingState(),
        GenericLoadedState(data: [cartItem]),
      ],
      verify: (_) {
        verify(() => repository.addItem(product)).called(1);
        verify(() => repository.getCartItems()).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Error] when addItem is fail',
      build: () {
        when(() => repository.addItem(product)).thenAnswer(
          (_) async => Left(
            Failure(errorMessage: "Fail To Add Item"),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.addItem(product),
      expect: () => [
        GenericErrorState(errorMessage: "Fail To Add Item"),
      ],
      verify: (_) {
        verify(() => repository.addItem(product)).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Loaded] when removeItem is success',
      build: () {
        when(() => repository.removeItem(product.id))
            .thenAnswer((_) async => const Right(unit));
        when(() => repository.getCartItems())
            .thenAnswer((_) async => const Right(<Cart>[]));
        return cubit;
      },
      act: (cubit) => cubit.removeItem(product.id),
      expect: () => [
        GenericLoadingState(),
        GenericLoadedState(data: const <Cart>[]),
      ],
      verify: (_) {
        verify(() => repository.removeItem(product.id)).called(1);
        verify(() => repository.getCartItems()).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Error] when removeItem is fail',
      build: () {
        when(() => repository.removeItem(product.id)).thenAnswer(
          (_) async => Left(
            Failure(errorMessage: "Fail To Remove Item"),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.removeItem(product.id),
      expect: () => [
        GenericErrorState(errorMessage: "Fail To Remove Item"),
      ],
      verify: (_) {
        verify(() => repository.removeItem(product.id)).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Loaded] when increaseQuantity is success',
      build: () {
        when(() => repository.increaseQuantity(product.id))
            .thenAnswer((_) async => const Right(unit));
        when(() => repository.getCartItems())
            .thenAnswer((_) async => Right(<Cart>[cartItem]));
        return cubit;
      },
      act: (cubit) => cubit.increaseQuantity(product.id),
      expect: () => [
        GenericLoadingState(),
        GenericLoadedState(data: <Cart>[cartItem]),
      ],
      verify: (_) {
        verify(() => repository.increaseQuantity(product.id)).called(1);
        verify(() => repository.getCartItems()).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Error] when increaseQuantity is fail',
      build: () {
        when(() => repository.increaseQuantity(product.id)).thenAnswer(
          (_) async => Left(
            Failure(errorMessage: "Fail To Increase Quantity"),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.increaseQuantity(product.id),
      expect: () => [
        GenericErrorState(errorMessage: "Fail To Increase Quantity"),
      ],
      verify: (_) {
        verify(() => repository.increaseQuantity(product.id)).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Loaded] when decreaseQuantity is success',
      build: () {
        when(() => repository.decreaseQuantity(product.id))
            .thenAnswer((_) async => const Right(unit));
        when(() => repository.getCartItems())
            .thenAnswer((_) async => Right(<Cart>[cartItem]));
        return cubit;
      },
      act: (cubit) => cubit.decreaseQuantity(product.id),
      expect: () => [
        GenericLoadingState(),
        GenericLoadedState(data: <Cart>[cartItem]),
      ],
      verify: (_) {
        verify(() => repository.decreaseQuantity(product.id)).called(1);
        verify(() => repository.getCartItems()).called(1);
      },
    );

    blocTest<CartCubit, GenericState>(
      'Should emit [Loading,Error] when decreaseQuantity is fail',
      build: () {
        when(() => repository.decreaseQuantity(product.id)).thenAnswer(
          (_) async => Left(
            Failure(errorMessage: "Fail To Decrease Quantity"),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.decreaseQuantity(product.id),
      expect: () => [
        GenericErrorState(errorMessage: "Fail To Decrease Quantity"),
      ],
      verify: (_) {
        verify(() => repository.decreaseQuantity(product.id)).called(1);
      },
    );
  });

  blocTest<CartCubit, GenericState>(
    'Should emit [Loaded] when clearCart is success',
    build: () {
      when(() => repository.clearCart())
          .thenAnswer((_) async => const Right(unit));
      return cubit;
    },
    act: (cubit) => cubit.clearCart(),
    expect: () => [
      GenericLoadedState(data: const []),
    ],
    verify: (_) {
      verify(() => repository.clearCart()).called(1);
    },
  );

  blocTest<CartCubit, GenericState>(
    'Should emit [Error] when clearCart is fail',
    build: () {
      when(() => repository.clearCart()).thenAnswer(
          (_) async => Left(Failure(errorMessage: "Fail To Clear Cart")));
      return cubit;
    },
    act: (cubit) => cubit.clearCart(),
    expect: () => [
      GenericErrorState(errorMessage: "Fail To Clear Cart"),
    ],
    verify: (_) {
      verify(() => repository.clearCart()).called(1);
    },
  );
}
