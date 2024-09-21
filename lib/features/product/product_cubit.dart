import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/product/product.dart';
import 'package:store/features/product/product_repository.dart';

class ProductCubit extends Cubit<GenericState> {
  final ProductRepository productRepository;
  List<Product> _products = [];
  List<Product> get products => _products;
  ProductCubit({
    required this.productRepository,
  }) : super(GenericInitializeState());

  Future<void> fetch({int? categoryId, String? title}) async {
    emit(GenericLoadingState());
    final result = await productRepository.getProduct(
      categoryId: categoryId,
      title: title,
    );
    result.fold((l) {
      emit(GenericErrorState(errorMessage: l.errorMessage));
    }, (r) {
      _products = r;
      emit(GenericLoadedState<List<Product>>(data: r));
    });
  }
}
