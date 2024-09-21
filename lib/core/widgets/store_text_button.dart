import 'package:flutter/material.dart';

class StoreTextButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const StoreTextButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(decoration: TextDecoration.underline),
      ),
    );
  }
}
