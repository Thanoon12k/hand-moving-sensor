import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';
import 'package:wifi/stt_controller.dart';
import 'package:wifi/tts_controller.dart';
import 'package:wifi/widgets/google_mic.dart';
import 'package:wifi/widgets/rounded_button.dart';
import 'package:wifi/widgets/widgets.dart';
import 'package:wifi/wifi.dart';

class HomeOld extends StatelessWidget {
  EspManager espcontroller = Get.put(EspManager());
  Text2SpeechManager ttscontroller = Get.put(Text2SpeechManager());
  Speech2TextManager sttcontroller = Get.put(Speech2TextManager());
  var buttontext = "new";

  HomeOld({super.key});
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
      body: Column(children: [
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          alignment: Alignment.topCenter,
          child: const Text(
            'The World Need Your Voice',
            style: TextStyle(
              fontSize: 25,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 45),
        Container(
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
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => Text(
                espcontroller.new_word.value,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.purple,
                  fontWeight: FontWeight.w700,
                  decorationColor: Colors.purple,
                  decorationThickness: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
              icon: Icons.mic,
              text: "TALK NOW",
              controller: espcontroller,
              sttcontroller: sttcontroller,
              ttscontroller: ttscontroller,
            ),
            RoundButton(
              icon: Icons.back_hand,
              text: "MOVE HAND",
              controller: espcontroller,
              sttcontroller: sttcontroller,
              ttscontroller: ttscontroller,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        TextContainer(text: espcontroller.new_word.value),
      ]),
    );
  }
}
