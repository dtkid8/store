import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store/core/failure.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/product/product.dart';
import 'package:store/features/product/product_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:store/features/product/product_response.dart';
import '../../mock.dart';
import '../../response.dart';

void main() {
  late ProductCubit cubit;
  late MockProductRepository repository;
  final List<Product> mockProducts = [];

  setUp(() {
    repository = MockProductRepository();
    cubit = ProductCubit(productRepository: repository);
    mockProducts.add(Product.fromResponse(ProductResponse.fromMap(productResponse)));
  });

  group("ProductCubit", () {
    test('Initial state should be initialize', () {
      expect(cubit.state, GenericInitializeState());
      expect(cubit.products, []);
    });

    blocTest<ProductCubit, GenericState>(
      "Should emit [Loading,Loaded] when fetch data is success",
      build: () {
        when(() => repository.getProduct(categoryId: 1, title: "a")).thenAnswer(
          (_) async => Right(
            mockProducts,
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.fetch(categoryId: 1, title: "a"),
      expect: () => [
        GenericLoadingState(),
        GenericLoadedState(
          data: mockProducts,
        )
      ],
      verify: (cubit) {
        verify(() => repository.getProduct(categoryId: 1, title: "a"))
            .called(1);
        expect(cubit.products, equals(mockProducts));
      },
    );

    blocTest<ProductCubit, GenericState>(
      "Should emit [Loading,Error] when fetch data is fail",
      build: () {
        when(() => repository.getProduct(categoryId: 1, title: "a")).thenAnswer(
          (_) async => Left(
            Failure(errorMessage: "Request Error"),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.fetch(categoryId: 1, title: "a"),
      expect: () => [
        GenericLoadingState(),
        GenericErrorState(errorMessage: "Request Error"),
      ],
      verify: (cubit) {
        verify(() => repository.getProduct(categoryId: 1, title: "a"))
            .called(1);
        expect(cubit.products, equals([]));
      },
    );
  });
}
