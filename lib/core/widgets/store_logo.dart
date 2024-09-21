import 'package:flutter/material.dart';

import '../images.dart';

class StoreLogo extends StatelessWidget {
  final double? size;
  final TextStyle? style;
  final bool isShowSlogan;
  const StoreLogo({
    super.key,
    this.size,
    this.style,
    this.isShowSlogan = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage(Images.images),
              height: size ?? 60,
              width: size ?? 60,
            ),
            Text(
              "hop IT",
              style: style ?? Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        isShowSlogan
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Shop from Our stores with ease",
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
