import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';
import 'package:wifi/stt_controller.dart';
import 'package:wifi/tts_controller.dart';
import 'package:wifi/wifi.dart';

class HomeScreen extends StatelessWidget {
  EspManager espcontroller = Get.put(EspManager());
  Text2SpeechManager ttscontroller = Get.put(Text2SpeechManager());
  Speech2TextManager sttcontroller = Get.put(Speech2TextManager());
  var buttontext = "new";

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.wifi,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                espcontroller.current_mode.value = "idle";
                Get.to(() => WIFISCREEN());
              }),
          title: const Text(
            'REACH TO ALL',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => ElevatedButton(
                onPressed: () => sttcontroller.toggleLanguage(),
                child: MyText(buttontext: sttcontroller.language.value),
              ),
            ),
            Obx(
              () => MyText(buttontext: sttcontroller.talk_text.value),
            ),
            Obx(
              () => MyText(buttontext: espcontroller.new_word.value),
            ),
            Row(
              children: [
                MyButton(
                    buttontext: "GET DATA",
                    controller: espcontroller,
                    ttscontroller: ttscontroller,
                    sttcontroller: sttcontroller),
                MyButton(
                    buttontext: 'SET IDLE',
                    controller: espcontroller,
                    ttscontroller: ttscontroller,
                    sttcontroller: sttcontroller),
                MyButton(
                    buttontext: "TALK",
                    controller: espcontroller,
                    ttscontroller: ttscontroller,
                    sttcontroller: sttcontroller),
              ],
            ),
            Obx(
              () => MyText(
                  buttontext: "mode ${espcontroller.current_mode.value}"),
            ),
            Obx(
              () => MyText(
                  buttontext:
                      "espconniction ${espcontroller.connection_status.value}"),
            ),
            Obx(
              () => espcontroller.current_mode.value == "waiting_speak"
                  ? const CircularProgressIndicator()
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
    required this.sttcontroller,
  });

  final String buttontext;
  final EspManager controller;
  final Text2SpeechManager ttscontroller;
  final Speech2TextManager sttcontroller;
  void _listenPress() async {
    await controller.ListernToEsp();
  }

  void _talkPress() async {
    controller.current_mode.value = "waiting_speak";
    await ttscontroller.speak(controller.new_word.value);
    controller.current_mode.value = "talking";
  }

  void _idlePress() {
    controller.current_mode.value = "idle";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
          onPressed: () {
            debugPrint("button -$buttontext  clicked");
            if (buttontext == "GET DATA") {
              _listenPress();
            } else if (buttontext == "TALK") {
              _talkPress();
            } else if (buttontext == "SET IDLE") {
              _idlePress();
            }
          },
          child: Text(
            buttontext,
            style: const TextStyle(color: Colors.white, fontSize: 24),
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
      padding: const EdgeInsets.all(8),
      child: Text(
        buttontext,
        style: const TextStyle(color: Colors.purple, fontSize: 24),
      ),
    );
  }
}
