import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';
import 'package:wifi/tts_controller.dart';

class HomeScreen extends StatelessWidget {
  EspManager espcontroller = Get.put(EspManager());
  Text2SpeechManager ttscontroller = Get.put(Text2SpeechManager());
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
            Obx(
              () => MyText(buttontext: espcontroller.connection_status.value),
            ),
            Obx(
              () => MyText(buttontext: espcontroller.new_word.value),
            ),
            Row(
              children: [
                MyButton(
                    buttontext: "GET DATA",
                    controller: espcontroller,
                    ttscontroller: ttscontroller),
                MyButton(
                    buttontext: 'SET IDLE',
                    controller: espcontroller,
                    ttscontroller: ttscontroller),
                MyButton(
                    buttontext: "TALK",
                    controller: espcontroller,
                    ttscontroller: ttscontroller),
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
    required this.ttscontroller,
  });

  final String buttontext;
  final EspManager controller;
  final Text2SpeechManager ttscontroller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(8),
      child: ElevatedButton(
          onPressed: () async {
            if (buttontext == "GET DATA") {
              controller.mode.value = "esp";
              await controller.initSocket();
            } else if (buttontext == "TALK") {
              controller.mode.value = "talking";
            } else if (buttontext == "SET IDLE") {
              ttscontroller.speak(controller.new_word.value);
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
