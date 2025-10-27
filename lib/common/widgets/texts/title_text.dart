import 'package:flutter/material.dart';

class TTitleText extends StatelessWidget {
  const TTitleText({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
