import 'package:flutter/material.dart';
import 'package:store/core/extension.dart';

class CategoryCard extends StatefulWidget {
  final Function()? onTap;
  final bool isSelected;
  final String label;
  const CategoryCard({
    super.key,
    this.onTap,
    this.isSelected = false,
    required this.label,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
      },
      child: Card(
        color: widget.isSelected ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              widget.label.capitalizeEachWord(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: widget.isSelected ? Colors.white : Colors.black,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
