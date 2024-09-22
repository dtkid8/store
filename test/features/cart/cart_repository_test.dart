import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:store/features/cart/cart.dart';
import 'package:store/features/cart/cart_repository.dart';
import 'package:store/features/product/product.dart';
import 'package:store/features/category/category.dart';

import '../../mock.dart';


void main() {
  late CartRepository cartRepository;
  late MockCartBox mockBox;

  setUp(() {
    mockBox = MockCartBox();
    cartRepository = CartRepository(mockBox);
  });

  group('CartRepository', () {
    final product = Product(
      id: 1,
      title: "Sample Product",
      price: 100,
      description: "Sample Description",
      images: [],
      creationAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: Category(
        id: 1,
        name: "Sample Category",
        image: "",
        creationAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    test('getCartItems returns list of cart items', () async {
      final cartItem = Cart(product: product, quantity: 1);
      when(() => mockBox.values).thenReturn([cartItem].toList());

      final result = await cartRepository.getCartItems();

      result.fold((_) => {}, (r) {
        expect(r, [cartItem]);
      });
    });

    test('addItem adds a new product to the cart', () async {
      when(() => mockBox.values).thenReturn([]);
      final cartItem = Cart(product: product, quantity: 1);
      final result = await cartRepository.addItem(product);

      verify(() => mockBox.add(cartItem)).called(1);
      result.fold((_) => {}, (r) {
        expect(r, unit);
      });
    });

    test('addItem increases quantity if product already in cart', () async {
      final existingCartItem = Cart(product: product, quantity: 1);
      when(() => mockBox.values).thenReturn([existingCartItem]);

      final result = await cartRepository.addItem(product);

      result.fold((_) => {}, (r) {
        expect(r, unit);
        expect(existingCartItem.quantity, 2);
      });
    });

    test('removeItem removes an existing product from the cart', () async {
      final existingCartItem = Cart(product: product, quantity: 1);
      when(() => mockBox.values).thenReturn([existingCartItem]);

      final result = await cartRepository.removeItem(product.id);

      result.fold((_) => {}, (r) {
        expect(r, unit);
      });
    });

    test('increaseQuantity increases the quantity of an existing cart item',
        () async {
      final existingCartItem = Cart(product: product, quantity: 1);
      when(() => mockBox.values).thenReturn([existingCartItem]);

      final result = await cartRepository.increaseQuantity(product.id);

      expect(existingCartItem.quantity, 2);
      result.fold((_) => {}, (r) {
        expect(r, unit);
        expect(existingCartItem.quantity, 2);
      });
    });

    test('decreaseQuantity decreases the quantity of an existing cart item',
        () async {
      final existingCartItem = Cart(product: product, quantity: 2);
      when(() => mockBox.values).thenReturn([existingCartItem]);

      final result = await cartRepository.decreaseQuantity(product.id);

      result.fold((_) => {}, (r) {
        expect(r, unit);
        expect(existingCartItem.quantity, 1);
      });
    });

    test('clearCart clears all items from the cart', () async {
      final result = await cartRepository.clearCart();

      verify(() => mockBox.clear()).called(1);
      result.fold((_) => {}, (r) {
        expect(r, unit);
      });
    });
  });
}
