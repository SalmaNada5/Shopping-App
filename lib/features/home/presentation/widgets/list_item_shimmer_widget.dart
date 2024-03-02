import 'package:flutter/material.dart';

class ListItemShimmerWidget extends StatelessWidget {
  const ListItemShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 120,
          child: Image.asset("assets/images/placeholder.png"),
        ),
        const Text(
          "brand",
        ),
        const Text(
          "name",
        ),
        const Text(
          "10\$",
        ),
      ],
    );
  }
}
