import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/extension.dart';
import 'package:store/features/cart/cart_cubit.dart';
import 'package:store/features/product/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      _goToPreviousPage();
    } else if (details.primaryVelocity! < 0) {
      _goToNextPage();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.product.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void didUpdateWidget(covariant ProductDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width;
    Random random = Random();
    double randomRating = 1.0 + (random.nextDouble() * 4.0);
    int randomReview = random.nextInt(100);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<CartCubit>().addItem(widget.product);
          },
          child: const Text("Add To Cart"),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Hero(
                      tag: widget.product.id,
                      child: SizedBox(
                        width: imageSize,
                        height: imageSize,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onHorizontalDragEnd: _handleSwipe,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: widget.product.images.length,
                                onPageChanged: _onPageChanged,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.product.images[index],
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible: _currentPage > 0,
                              child: Positioned(
                                left: 16,
                                top: imageSize / 2 - 20,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                  ),
                                  onPressed: _goToPreviousPage,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _currentPage <
                                  widget.product.images.length - 1,
                              child: Positioned(
                                right: 16,
                                top: imageSize / 2 - 20,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                  ),
                                  onPressed: _goToNextPage,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              bottom: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_currentPage + 1}/${widget.product.images.length}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rp ${widget.product.price.format()}",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Icon(
                                Icons.favorite,
                                size: 32,
                              )
                            ],
                          ),
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    child: const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    randomRating.toStringAsFixed(1),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                              Text(
                                "${randomReview.toString()} Reviews",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Text(
                            widget.product.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16.0,
              left: 16.0,
              child: IconButton(
                iconSize: 32,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: IconButton(
                iconSize: 32,
                onPressed: () {
                  Navigator.pushNamed(context, "/cart").then(
                    (value) => SystemChrome.setEnabledSystemUIMode(
                        SystemUiMode.immersiveSticky),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
