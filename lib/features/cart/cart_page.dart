import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/extension.dart';
import 'package:store/core/generic_state.dart';
import 'package:store/features/cart/cart_cubit.dart';
import 'package:store/features/cart/cart_list_card.dart';
import 'cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    context.read<CartCubit>().loadCartItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
            },
            icon: const Icon(Icons.delete),
            iconSize: 32,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<CartCubit, GenericState>(
                  builder: (context, state) {
                    if (state is GenericLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    } else if (state is GenericErrorState) {
                      return Center(
                        child: Text('Error: ${state.errorMessage}'),
                      );
                    }
                    final List<Cart> carts = context.read<CartCubit>().cart;
                    if (carts.isEmpty) {
                      return const Center(
                        child: Text("Cart is Empty."),
                      );
                    }
                    return ListView.builder(
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        final cart = carts[index];
                        return CartListCard(
                          cart: cart,
                        );
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<CartCubit, GenericState>(
                builder: (context, state) {
                  final count = context.read<CartCubit>().count;
                  final totalPrice = context.read<CartCubit>().totalPrice;
                  return count > 0
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total ${count.format()} items"),
                                Text("Rp ${totalPrice.format()}",style: Theme.of(context).textTheme.titleLarge,),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Proccess To Checkout"),
                                  Icon(Icons.arrow_forward)
                                ],
                              ),
                            )
                          ],
                        )
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
