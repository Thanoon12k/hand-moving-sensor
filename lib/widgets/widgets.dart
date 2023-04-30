import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  const TextContainer({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.topCenter,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 25,
          color: Colors.pinkAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

