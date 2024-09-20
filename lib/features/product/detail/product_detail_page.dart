import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  }

  @override
  void dispose() {
    _pageController.dispose();
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width;

    return Scaffold(
      body: Stack(
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
                            visible:
                                _currentPage < widget.product.images.length - 1,
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
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.product.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.product.description,
                      style: const TextStyle(fontSize: 16),
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
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
    );
  }
}
