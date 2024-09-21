import 'package:flutter/material.dart';

import '../product.dart';
import 'product_grid_card.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return ProductCardGrid(product: widget.products[index]);
      },
    );
  }
}
