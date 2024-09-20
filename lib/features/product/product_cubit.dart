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

  void fetch() async {
    emit(GenericLoadingState());
    final result = await productRepository.getProduct();
    result.fold((l) {
      emit(GenericErrorState(errorMessage: l.errorMessage));
    }, (r) {
      _products = r;
      emit(GenericLoadedState<List<Product>>(data: r));
    });
  }
}
