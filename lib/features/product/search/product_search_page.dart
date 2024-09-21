import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/widgets/store_text_form_field.dart';
import 'package:store/features/product/product_cubit.dart';
import 'package:store/features/product/widget/product_list_card.dart';
import 'package:store/features/product/product_repository.dart';
import '../../../core/generic_state.dart';
import '../product.dart';

class ProductSearchPage extends StatelessWidget {
  const ProductSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(
        productRepository: context.read<ProductRepository>(),
      ),
      child: const ProductSearchView(),
    );
  }
}

class ProductSearchView extends StatefulWidget {
  const ProductSearchView({super.key});

  @override
  State<ProductSearchView> createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<ProductSearchView> {
  final _searchController = TextEditingController();
  bool _showIconDeleteSearch = false;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
            iconSize: 32,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StoreTextFormField(
              controller: _searchController,
              label: "Search",
              hintText: "Enter a Product Title",
              suffixIcon: _showIconDeleteSearch
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _showIconDeleteSearch = false;
                        });
                      },
                      icon: const Icon(Icons.close),
                    )
                  : null,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context.read<ProductCubit>().fetch(title: value);
                }
                setState(() {
                  _showIconDeleteSearch = value.isNotEmpty ? true : false;
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ProductCubit, GenericState>(
                builder: (context, state) {
                  if (state is GenericLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  } else if (state is GenericLoadedState) {
                    final List<Product> products = state.data;
                    if (products.isEmpty) {
                      return const Center(
                        child: Text("No products found."),
                      );
                    }
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductListCard(product: products[index]);
                      },
                    );
                  } else if (state is GenericErrorState) {
                    return Center(
                      child: Text('Error: ${state.errorMessage}'),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
