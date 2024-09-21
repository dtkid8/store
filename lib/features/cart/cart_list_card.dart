import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/extension.dart';
import 'package:store/core/widgets/store_icon_border.dart';
import 'package:store/features/cart/cart.dart';
import 'package:store/features/cart/cart_cubit.dart';

class CartListCard extends StatefulWidget {
  final Cart cart;

  const CartListCard({
    super.key,
    required this.cart,
  });

  @override
  State<CartListCard> createState() => _CartListCardState();
}

class _CartListCardState extends State<CartListCard>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/productDetail',
          arguments: widget.cart.product,
        );
      },
      child: ScaleTransition(
        scale: _animation,
        child: FadeTransition(
          opacity: _animation,
          child: Card(
            elevation: 8.0,
            shadowColor: Colors.black.withOpacity(0.5),
            child: SizedBox(
              height: size.width * 0.35,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.cart.product.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: CachedNetworkImage(
                        width: size.width * 0.35,
                        height: size.width * 0.35,
                        fit: BoxFit.cover,
                        imageUrl: widget.cart.product.images[0],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cart.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            "Rp ${widget.cart.product.price.format()}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Row(
                                children: [
                                  StoreIconBorder(
                                    icon: Icons.remove,
                                    onTap: () {
                                      context
                                          .read<CartCubit>()
                                          .decreaseQuantity(
                                              widget.cart.product.id);
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    widget.cart.quantity.format(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(width: 16),
                                  StoreIconBorder(
                                    icon: Icons.add,
                                    onTap: () {
                                      context
                                          .read<CartCubit>()
                                          .increaseQuantity(
                                              widget.cart.product.id);
                                    },
                                  ),
                                ],
                              ),
                              const Spacer(),
                              StoreIconBorder(
                                icon: Icons.delete,
                                onTap: () {
                                  context
                                      .read<CartCubit>()
                                      .removeItem(widget.cart.product.id);
                                },
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
