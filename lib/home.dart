import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';

class HomeScreen extends StatelessWidget {
  EspManager espcontroller = Get.put(EspManager());
  var buttontext = "new";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'REACH TO ALL',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<String?>(
                stream: espcontroller.mydatastream,
                builder: (_, snapshot) {
                  debugPrint("sanp ${snapshot.connectionState.name}");
                  if (snapshot.hasData) {
                    return MyText(
                      buttontext: snapshot.data.toString(),
                    );
                  } else {
                    return const MyText(
                      buttontext: "no data here",
                    );
                  }
                }),
            Obx(
              () => MyButton(
                  buttontext: espcontroller.new_word.value,
                  controller: espcontroller),
            ),
            Row(
              children: [
                MyButton(buttontext: "GET DATA", controller: espcontroller),
                MyButton(buttontext: 'SET IDLE', controller: espcontroller),
                MyButton(buttontext: "TALK", controller: espcontroller),
              ],
            ),
            Obx(
              () => MyText(buttontext: espcontroller.mode.value),
            ),
            Obx(
              () => espcontroller.waiting_now.value
                  ? CircularProgressIndicator()
                  : Container(),
            )
          ],
        ));
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.buttontext,
    required this.controller,
  });

  final String buttontext;
  final EspManager controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
          onPressed: () {
            if (buttontext == "GET DATA") {
              controller.GetEspData();
              controller.mode.value = "esp";
            } else if (buttontext == "TALK") {
              controller.mode.value = "talking";
            } else if (buttontext == "SET IDLE") {
              controller.mode.value = "idle";
            }
          },
          child: Text(
            buttontext,
            style: TextStyle(color: Colors.white, fontSize: 24),
          )),
    );
  }
}

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    required this.buttontext,
  });

  final String buttontext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text(
        buttontext,
        style: TextStyle(color: Colors.purple, fontSize: 24),
      ),
    );
  }
}
