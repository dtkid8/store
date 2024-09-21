import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:store/features/category/category.dart';
import 'package:store/features/category/category_response.dart';
import '../../core/failure.dart';
import '../../core/url.dart';

abstract class CategoryRepositoryProtocol {
  Future<Either<Failure, List<Category>>> getCategory();
}

class CategoryRepository extends CategoryRepositoryProtocol {
  final Dio client;

  CategoryRepository({required this.client});
  @override
  Future<Either<Failure, List<Category>>> getCategory() async {
    try {
      final request = await client.get(
        Url.category,
      );
      if (request.statusCode == 200) {
        final List<CategoryResponse> response = List<CategoryResponse>.from(
            request.data.map((x) => CategoryResponse.fromMap(x)));
        final List<Category> categories =
            response.map((e) => Category.fromResponse(e)).toList();
        return Right(categories);
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
