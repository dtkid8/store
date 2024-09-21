import 'dart:convert';
import 'package:hive/hive.dart';
import '../product/product.dart';
part 'cart.g.dart';

@HiveType(typeId: 3)
class Cart extends HiveObject {
  @HiveField(0)
  final Product product;
  @HiveField(1)
  int quantity;

  Cart({
    required this.product,
    required this.quantity,
  });

  Cart copyWith({
    Product? product,
    int? quantity,
  }) {
    return Cart(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      product: Product.fromMap(map['product'] as Map<String,dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Cart(product: $product, quantity: $quantity)';

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;
  
    return 
      other.product == product &&
      other.quantity == quantity;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}
