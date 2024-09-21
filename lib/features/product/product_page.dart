import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/widgets/store_logo.dart';
import 'package:store/features/auth/auth_cubit.dart';
import 'package:store/features/category/category_card.dart';
import 'package:store/features/category/category_cubit.dart';
import 'package:store/features/category/category_repository.dart';
import 'package:store/features/product/product.dart';
import 'package:store/features/product/product_cubit.dart';
import 'package:store/features/product/widget/product_grid.dart';
import 'package:store/features/product/product_repository.dart';
import '../../core/generic_state.dart';
import '../auth/user.dart';
import '../category/category.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductCubit(
            productRepository: context.read<ProductRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(
              categoryRepository: context.read<CategoryRepository>()),
        ),
      ],
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
    context.read<ProductCubit>().fetch();
    context.read<CategoryCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.person),
            iconSize: 32,
          );
        }),
        title: const StoreLogo(
          size: 24,
          isShowSlogan: false,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/search");
            },
            icon: const Icon(Icons.search),
            iconSize: 32,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/cart");
            },
            icon: const Icon(Icons.shopping_cart),
            iconSize: 32,
          )
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BlocBuilder<AuthCubit, GenericState>(
              builder: (context, state) {
                final User user = context.read<AuthCubit>().user;
                return DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                context.read<AuthCubit>().logout();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AuthCubit, GenericState>(
              builder: (context, state) {
                final User user = context.read<AuthCubit>().user;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi ${user.email}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "What are you looking for today?",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<CategoryCubit, GenericState>(
              builder: (context, state) {
                if (state is GenericLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                } else if (state is GenericLoadedState) {
                  final List<Category> categories = state.data;
                  final int selectedIndex =
                      context.read<CategoryCubit>().selectedIndex;
                  return SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryCard(
                          isSelected: selectedIndex == index,
                          onTap: () {
                            context.read<CategoryCubit>().change(index);
                            context.read<ProductCubit>().fetch(
                                categoryId:
                                    index == 0 ? null : categories[index].id);
                          },
                          label: category.name,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 4,
            ),
            BlocBuilder<ProductCubit, GenericState>(
              builder: (context, state) {
                final List<Product> products =
                    context.read<ProductCubit>().products;
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ProductGrid(products: products),
                      ),
                      state is GenericLoadingState
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
