import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'HomeOld.dart';
import 'homeok.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reach To All',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: HomeOld(),
    );
  }
}
