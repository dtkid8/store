import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:store/core/failure.dart';
import 'package:store/features/cart/cart.dart';
import 'package:store/features/category/category.dart';
import 'package:store/features/product/product.dart';

abstract class CartRepositoryProtocol {
  Future<Either<Failure, List<Cart>>> getCartItems();
  Future<Either<Failure, Unit>> addItem(Product product);
  Future<Either<Failure, Unit>> removeItem(int productId);
  Future<Either<Failure, Unit>> increaseQuantity(int productId);
  Future<Either<Failure, Unit>> decreaseQuantity(int productId);
  Future<Either<Failure, Unit>> clearCart();
}

class CartRepository implements CartRepositoryProtocol {
  final Box<Cart> cartBox;

  CartRepository(this.cartBox);
  final Cart defaultCart = Cart(
      product: Product(
        id: 0,
        title: "",
        price: 0,
        description: "",
        images: [],
        creationAt: DateTime(0),
        updatedAt: DateTime(0),
        category: Category(
          id: 0,
          name: "",
          image: "",
          creationAt: DateTime(0),
          updatedAt: DateTime(0),
        ),
      ),
      quantity: 0);
  @override
  Future<Either<Failure, List<Cart>>> getCartItems() async {
    try {
      final cartItems = cartBox.values.toList();
      return Right(cartItems);
    } catch (e, stackTrace) {
      return Left(Failure(
        errorMessage: 'Failed to load cart items',
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(Product product) async {
    try {
      final Cart existingItem = cartBox.values.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => defaultCart,
      );

      if (existingItem.product.id != 0) {
        return increaseQuantity(product.id);
      } else {
        final cartItem = Cart(product: product, quantity: 1);
        cartBox.add(cartItem);
      }
      return const Right(unit);
    } catch (e, stackTrace) {
      return Left(Failure(
        errorMessage: 'Failed to add item',
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeItem(int productId) async {
    try {
      final existingItem = cartBox.values.firstWhere(
        (item) => item.product.id == productId,
        orElse: () => defaultCart,
      );

      if (existingItem.product.id != 0) {
        existingItem.delete();
      }
      return const Right(unit);
    } catch (e, stackTrace) {
      return Left(Failure(
        errorMessage: 'Failed to remove item',
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> increaseQuantity(int productId) async {
    try {
      final existingItem = cartBox.values.firstWhere(
        (item) => item.product.id == productId,
        orElse: () => defaultCart,
      );

      if (existingItem.product.id != 0) {
        existingItem.quantity++;
        existingItem.save(); 
      }
      return const Right(unit);
    } catch (e, stackTrace) {
      return Left(Failure(
        errorMessage: 'Failed to increase quantity',
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> decreaseQuantity(int productId) async {
    try {
      final existingItem = cartBox.values.firstWhere(
        (item) => item.product.id == productId,
        orElse: () => defaultCart,
      );

      if (existingItem.product.id != 0) {
        if (existingItem.quantity > 1) {
          existingItem.quantity--;
          existingItem.save();
        } else {
          removeItem(productId);
        }
      }
      return const Right(unit);
    } catch (e, stackTrace) {
      return Left(Failure(
        errorMessage: 'Failed to decrease quantity',
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      cartBox.clear();
      return const Right(unit);
    } catch (e, stackTrace) {
      return Left(Failure(
        errorMessage: 'Failed to clear cart',
        stackTrace: stackTrace,
      ));
    }
  }
}
