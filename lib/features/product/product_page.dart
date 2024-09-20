import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/auth_cubit.dart';
import 'package:store/features/product/product.dart';
import 'package:store/features/product/product_cubit.dart';
import 'package:store/features/product/widget/product_grid.dart';
import 'package:store/features/product/product_repository.dart';
import '../../core/generic_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductCubit(productRepository: context.read<ProductRepository>()),
      child: const ProductView(),
    );
  }
}

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().check();
    context.read<ProductCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, GenericState>(
      listener: (context, state) {
        if (state is GenericInitializeState) {
          Navigator.pushReplacementNamed(context, "/login");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Product"),
        ),
        body: BlocBuilder<ProductCubit, GenericState>(
          builder: (context, state) {
            final List<Product> products =
                context.read<ProductCubit>().products;
            return Column(
              children: [
                Expanded(child: ProductGrid(products: products)),
                state is GenericLoadingState
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            );
          },
        ),
      ),
    );
  }
}
