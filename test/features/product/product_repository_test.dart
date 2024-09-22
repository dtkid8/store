import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store/core/url.dart';
import 'package:store/features/product/product_repository.dart';
import '../../mock.dart';

void main() {
  late ProductRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = ProductRepository(client: mockDio);
  });

  group('ProductRepository', () {
    test('getProduct returns a list of products on success', () async {
      // Arrange
      final List<Map<String, dynamic>> response = [
        {
          "id": 4,
          "title": "Handmade Fresh Table",
          "price": 687,
          "description": "Andy shoes are designed to keeping in...",
          "category": {
            "id": 5,
            "name": "Others",
            "image": "https://placeimg.com/640/480/any?r=0.591926261873231"
          },
          "images": [
            "https://placeimg.com/640/480/any?r=0.9178516507833767",
            "https://placeimg.com/640/480/any?r=0.9300320592588625",
            "https://placeimg.com/640/480/any?r=0.8807778235430017"
          ]
        }
      ];

      when(() => mockDio.get(Url.product, queryParameters: {}))
          .thenAnswer((_) async => Response(
                data: response,
                statusCode: 200,
                requestOptions: RequestOptions(path: Url.product),
              ));

      // Act
      final result = await repository.getProduct();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected right but got left: ${l.errorMessage}'),
        (products) {
          expect(products.length, 1);
          expect(products[0].title, 'Handmade Fresh Table');
        },
      );
      verify(() => mockDio.get(Url.product, queryParameters: {})).called(1);
    });

    test('getProduct returns a failure on DioException', () async {
      // Arrange
      when(() => mockDio.get(Url.product, queryParameters: {})).thenThrow(
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
      final result = await repository.getProduct();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(
              failure.errorMessage, contains('Request Error Connection Error'));
        },
        (_) => fail('Expected left but got right'),
      );

      verify(() => mockDio.get(Url.product, queryParameters: {})).called(1);
    });

    test('getProduct returns a failure on Exception', () async {
      // Arrange
      final exception = Exception("Output Error");
      when(() => mockDio.get(Url.product,
          queryParameters: any(named: 'queryParameters'))).thenThrow(exception);

      // Act
      final result = await repository.getProduct();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure.errorMessage,
              contains('General Error ${exception.toString()}'));
        },
        (_) => fail('Expected left but got right'),
      );
      verify(() => mockDio.get(Url.product, queryParameters: {})).called(1);
    });
  });
}
