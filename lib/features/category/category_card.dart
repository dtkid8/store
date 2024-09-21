import 'package:flutter/material.dart';
import 'package:store/core/extension.dart';

class CategoryCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call;
      },
      child: Card(
        color: isSelected ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              label.capitalizeEachWord(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
