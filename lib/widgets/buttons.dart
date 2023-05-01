import 'package:flutter/material.dart';

import '../controller.dart';
import '../stt_controller.dart';
import '../tts_controller.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final EspManager controller;
  final Text2SpeechManager ttscontroller;
  final Speech2TextManager sttcontroller;

  RoundButton({
    required this.icon,
    required this.color,
    required this.text,
    required this.controller,
    required this.ttscontroller,
    required this.sttcontroller,
  });

  void _talkPress() async {
    controller.current_mode.value = "waiting_speak";
    await sttcontroller.StartListining();
    controller.current_mode.value = "talking";
  }

  void _idlePress() {
    controller.current_mode.value = "idle";
  }

  void _getdataPress() async {
    controller.current_mode.value = "esp";

    if (controller.connection_status.value == "connected") {
      await ttscontroller.speak(controller.new_word.value);
      await controller.ListernToEsp();

      controller.current_mode.value = "esp";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
        child: Column(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  if (text == "GET DATA") {
                    _getdataPress();
                  } else if (text == "TALK") {
                    _talkPress();
                  } else if (text == "SET IDLE") {
                    _idlePress();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: color,
                  elevation: 5,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}
