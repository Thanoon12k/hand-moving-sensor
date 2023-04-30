import 'package:flutter/material.dart';

import '../controller.dart';
import '../stt_controller.dart';
import '../tts_controller.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final EspManager controller;
  final Text2SpeechManager ttscontroller;
  final Speech2TextManager sttcontroller;

  RoundButton({
    required this.icon,
    required this.text,
    required this.controller,
    required this.ttscontroller,
    required this.sttcontroller,
  });

  void _onTap() {
    debugPrint("tap ");
  }

  void _onLongPressend(LongPressEndDetails detail) {
    debugPrint("long press end ");
  }

  void _longPressStart(LongPressStartDetails detail) {
    debugPrint("long press start ");
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
              child: GestureDetector(
                onTap: _onTap,
                onLongPressStart: _longPressStart,
                onLongPressEnd: _onLongPressend,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.blue,
                    elevation: 5,
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}
