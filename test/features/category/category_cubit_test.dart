import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store/core/failure.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/category/category.dart';
import 'package:store/features/category/category_cubit.dart';
import 'package:store/features/category/category_response.dart';

import '../../mock.dart';
import '../../response.dart';

void main() {
  late CategoryCubit cubit;
  late MockCategoryRepository repository;
  final List<Category> mockCategories = [];
  final List<Category> defaultCategory = [
    Category(
      id: 0,
      name: "All",
      image: "",
      creationAt: DateTime(0),
      updatedAt: DateTime(0),
    )
  ];
  const int index = 0;
  setUp(() {
    repository = MockCategoryRepository();
    cubit = CategoryCubit(categoryRepository: repository);
    mockCategories
        .add(Category.fromResponse(CategoryResponse.fromMap(categoryResponse)));
  });

  group("ProductCubit", () {
    test('Initial state should be initialize', () {
      expect(cubit.state, GenericInitializeState());
      expect(cubit.categorys, defaultCategory);
      expect(cubit.selectedIndex, 0);
    });

    blocTest<CategoryCubit, GenericState>(
      "Should emit [Loading,Loaded] when fetch data is success",
      build: () {
        when(() => repository.getCategory()).thenAnswer(
          (_) async => Right(
            mockCategories,
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        GenericLoadingState(),
        GenericLoadedState(
          data: defaultCategory + mockCategories,
        )
      ],
      verify: (cubit) {
        verify(() => repository.getCategory()).called(1);
        expect(cubit.categorys, equals(defaultCategory + mockCategories));
      },
    );

    blocTest<CategoryCubit, GenericState>(
      "Should emit [Loading,Error] when fetch data is fail",
      build: () {
        when(() => repository.getCategory()).thenAnswer(
          (_) async => Left(
            Failure(errorMessage: "Request Error"),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        GenericLoadingState(),
        GenericErrorState(errorMessage: "Request Error"),
      ],
      verify: (cubit) {
        verify(() => repository.getCategory()).called(1);
        expect(cubit.categorys, equals(defaultCategory));
      },
    );

    blocTest<CategoryCubit, GenericState>(
      "Should emit [Action, Loaded] when change index",
      
      build: () {
        return cubit;
      },
      act: (cubit) => cubit.change(0),
      expect: () => [
        GenericActionLoadedState(message: "Change index $index"),
        GenericLoadedState(data: defaultCategory),
      ],
      verify: (cubit) {
        expect(cubit.selectedIndex, equals(index));
      },
    );
  });
}
