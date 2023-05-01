import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';
import 'package:wifi/stt_controller.dart';
import 'package:wifi/tts_controller.dart';
import 'package:wifi/widgets/buttons.dart';
import 'package:wifi/widgets/textContainers.dart';
import 'package:wifi/wifi.dart';

class HomeOk extends StatelessWidget {
  EspManager espcontroller = Get.put(EspManager());
  Text2SpeechManager ttscontroller = Get.put(Text2SpeechManager());
  Speech2TextManager sttcontroller = Get.put(Speech2TextManager());
  var buttontext = "new";

  HomeOk({super.key});
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
            const SizedBox(height: 25),
            const TitleText(titletext: 'The World Need Your Voice'),
            const SizedBox(height: 45),
            Obx(() => kReleaseMode
                ? AwsomeText(text: sttcontroller.talk_text.value)
                : AwsomeText(
                    text:
                        "( conn: ${espcontroller.connection_status.value} )    (mode  : ${espcontroller.current_mode.value}    )   (talk: ${sttcontroller.talk_text.value})    ( espdata:${espcontroller.new_word.value} )")),
            const SizedBox(height: 10),
            Obx(
              () => MyText(buttontext: sttcontroller.talk_text.value),
            ),
            Row(
              children: [
                Obx(
                  () => RoundButton(
                      color: espcontroller.current_mode.value == "esp"
                          ? Colors.orange
                          : Colors.blue,
                      icon: Icons.back_hand,
                      text: "GET DATA",
                      controller: espcontroller,
                      ttscontroller: ttscontroller,
                      sttcontroller: sttcontroller),
                ),
                Obx(
                  () => RoundButton(
                      color: espcontroller.current_mode.value == "talking"
                          ? Colors.orange
                          : Colors.blue,
                      icon: Icons.mic,
                      text: 'TALK',
                      controller: espcontroller,
                      ttscontroller: ttscontroller,
                      sttcontroller: sttcontroller),
                ),
                Obx(
                  () => RoundButton(
                      color: espcontroller.current_mode.value == "idle"
                          ? Colors.orange
                          : Colors.blue,
                      icon: Icons.timer_off,
                      text: 'SET IDLE',
                      controller: espcontroller,
                      ttscontroller: ttscontroller,
                      sttcontroller: sttcontroller),
                ),
              ],
            ),
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
  void _getPress() async {
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

  void _listenPress() async {
    await sttcontroller.StartListining();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
          onPressed: () {
            debugPrint("button -$buttontext  clicked");
            if (buttontext == "GET DATA") {
              _getPress();
            } else if (buttontext == "TALK") {
              _talkPress();
            } else if (buttontext == "SET IDLE") {
              _idlePress();
            } else if (buttontext == "LISTEN") {
              _listenPress();
            }
          },
          child: Text(
            buttontext,
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
        style: const TextStyle(color: Colors.purple, fontSize: 20),
      ),
    );
  }
}
