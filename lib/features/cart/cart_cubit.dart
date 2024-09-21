import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/cart/cart.dart';
import 'package:store/features/cart/cart_repository.dart';

import '../product/product.dart';

class CartCubit extends Cubit<GenericState> {
  final CartRepository cartRepository;
  List<Cart> _cart = [];
  List<Cart> get cart => _cart;

  int get count => _cart.length;

  double get totalPrice {
    double counter = 0;
    for (var element in _cart) {
      counter += (element.quantity * element.product.price);
    }
    return counter;
  }

  CartCubit({
    required this.cartRepository,
  }) : super(GenericInitializeState());

  Future<void> loadCartItems() async {
    emit(GenericLoadingState());
    final result = await cartRepository.getCartItems();
    result.fold(
      (failure) => emit(GenericErrorState(errorMessage: failure.errorMessage)),
      (cartItems) {
        _cart = cartItems;
        emit(GenericLoadedState(data: cartItems));
      },
    );
  }

  Future<void> addItem(Product product) async {
    final result = await cartRepository.addItem(product);
    result.fold(
      (failure) => emit(GenericErrorState(errorMessage: failure.errorMessage)),
      (_) => loadCartItems(),
    );
  }

  Future<void> removeItem(int productId) async {
    final result = await cartRepository.removeItem(productId);
    result.fold(
      (failure) => emit(GenericErrorState(errorMessage: failure.errorMessage)),
      (_) => loadCartItems(),
    );
  }

  Future<void> increaseQuantity(int productId) async {
    final result = await cartRepository.increaseQuantity(productId);
    result.fold(
      (failure) => emit(GenericErrorState(errorMessage: failure.errorMessage)),
      (_) => loadCartItems(),
    );
  }

  Future<void> decreaseQuantity(int productId) async {
    final result = await cartRepository.decreaseQuantity(productId);
    result.fold(
      (failure) => emit(GenericErrorState(errorMessage: failure.errorMessage)),
      (_) => loadCartItems(),
    );
  }

  Future<void> clearCart() async {
    final result = await cartRepository.clearCart();
    result.fold(
      (failure) => emit(GenericErrorState(errorMessage: failure.errorMessage)),
      (_) {
        _cart = [];
        emit(GenericLoadedState(data: const []));
      },
    );
  }
}
