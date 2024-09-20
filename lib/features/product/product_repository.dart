import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:store/core/failure.dart';
import 'package:store/core/url.dart';
import 'package:store/features/product/product.dart';
import 'package:store/features/product/product_response.dart';

abstract class ProductRepositoryProtocol {
  Future<Either<Failure, List<Product>>> getProduct({
    int? categoryId,
  });
}

class ProductRepository extends ProductRepositoryProtocol {
  final Dio client;
  ProductRepository({required this.client});
  @override
  Future<Either<Failure, List<Product>>> getProduct({
    int? categoryId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (categoryId != null) {
        queryParameters["categoryId"] = categoryId;
      }
      final request = await client.get(
        Url.product,
        queryParameters: queryParameters,
      );
      if (request.statusCode == 200) {
        final List<ProductResponse> response = List<ProductResponse>.from(
            request.data.map((x) => ProductResponse.fromMap(x)));

        final List<Product> products =
            response.map((e) => Product.fromResponse(e)).toList();
        return Right(products);
      }

      return Left(
        Failure(
          errorMessage: "Request Error ${request.statusMessage}",
          errorJson: request.data,
          statusCode: request.statusCode,
        ),
      );
    } on DioException catch (e, stackTrace) {
      return Left(
        Failure(
          errorMessage: "Request Error ${e.message}",
          errorJson: e.response?.data,
          stackTrace: stackTrace,
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(Failure(errorMessage: "General Error ${e.toString()}"));
    }
  }
}
