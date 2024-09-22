import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store/core/failure.dart';
import 'package:store/features/category/category_repository.dart';
import 'package:store/core/url.dart';

import '../../mock.dart';

void main() {
  late CategoryRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = CategoryRepository(client: mockDio);
  });

  group('CategoryRepository', () {
    test('getCategory returns a list of categories on success', () async {
      // Arrange
      final List<Map<String, Object>> response = [
        {
          'id': 1,
          'name': 'Category 1',
          'image': 'image1.png',
          'creationAt': "2024-09-21T04:13:46.000Z",
          'updatedAt': "2024-09-21T04:13:46.000Z",
        },
        {
          'id': 2,
          'name': 'Category 2',
          'image': 'image2.png',
          'creationAt': "2024-09-21T04:13:46.000Z",
          'updatedAt': "2024-09-21T04:13:46.000Z",
        },
      ];

      when(() => mockDio.get(Url.category)).thenAnswer((_) async => Response(
            data: response,
            statusCode: 200,
            requestOptions: RequestOptions(path: Url.category),
          ));

      // Act
      final result = await repository.getCategory();
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected right but got left: ${l.errorMessage}'),
        (categories) {
          expect(categories.length, 2);
          expect(categories[0].name, 'Category 1');
          expect(categories[1].name, 'Category 2');
        },
      );
      verify(() => mockDio.get(Url.category)).called(1);
    });

    test('getCategory returns failure on DioException', () async {
      // Arrange
      when(() => mockDio.get(Url.category)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: Url.category),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: Url.category),
          ),
          type: DioExceptionType.connectionError,
          message: 'Connection Error',
        ),
      );

      // Act
      final result = await repository.getCategory();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
          expect(failure.errorMessage, 'Request Error Connection Error');
        },
        (r) => fail('Expected left but got right: $r'),
      );
      verify(() => mockDio.get(Url.category)).called(1);
    });

    test('getCategory returns failure Exception', () async {
      // Arrange
      final exception = Exception("Output Error");
      when(() => mockDio.get(Url.category)).thenThrow(exception);

      // Act
      final result = await repository.getCategory();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
          expect(failure.errorMessage, 'General Error ${exception.toString()}');
        },
        (r) => fail('Expected left but got right: $r'),
      );
      verify(() => mockDio.get(Url.category)).called(1);
    });
  });
}
