import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AwsomeText extends StatelessWidget {
  const AwsomeText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            text,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.purple,
              fontWeight: FontWeight.w700,
              decorationColor: Colors.purple,
              decorationThickness: 2,
            ),
          ),
        ),
    
    );
  }
}

class TitleText extends StatelessWidget {
  final String titletext;
  const TitleText({
    required this.titletext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.topCenter,
      child: Text(
        titletext,
        style: const TextStyle(
          fontSize: 25,
          color: Colors.pinkAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
