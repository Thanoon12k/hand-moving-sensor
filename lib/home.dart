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
            onPressed: () => Get.to(() => WIFISCREEN()),
          ),
          title: const Text(
            'REACH TO ALL',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => ElevatedButton(onPressed:()=> sttcontroller.toggleLanguage(),child: MyText(buttontext:sttcontroller.language.value),),
            ),
           Obx(
              () => MyText(buttontext: sttcontroller.talk_text.value),
            ),
            Obx(
              () => MyText(buttontext: espcontroller.hand_text.value),
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
              () => MyText(buttontext: "mode ${espcontroller.mode.value}"),
            ),
            Obx(
              () => MyText(
                  buttontext:
                      "espconniction ${espcontroller.connection_status.value}"),
            ),
            Obx(
              () => espcontroller.waiting_now.value &&
                      espcontroller.mode.value == "esp"
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
          onPressed: () async {
            if (buttontext == "GET DATA") {
              await ttscontroller.speak(controller.hand_text.value);
              controller.mode.value = "esp";
              await controller.initSocket();
            } else if (buttontext == "TALK") {
              controller.mode.value = "talking";
              sttcontroller.StartListining();
            } else if (buttontext == "SET IDLE") {
              controller.mode.value = "idle";
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
