import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/printers.dart';
import 'package:wifi/tts_controller.dart';

class EspManager extends GetxController {
  late Timer myTimer;
  Text2SpeechManager speakmanager = Text2SpeechManager();
  RxString mode = "unknown".obs;
  RxString new_word = "unknown".obs;
  RxBool waiting_now = false.obs;
  RxString connection_status = "not connected".obs;
  late Socket espsocket;

  Future<void> initSocket() async {
    try {
      waiting_now.value = true;
      espsocket = await Socket.connect('192.168.43.78', 80,
          timeout: const Duration(minutes: 5));
      waiting_now.value = false;
      connection_status.value = "connected";
      printGreen("client : iam connected now");
    } catch (e) {
      waiting_now.value = false;
      connection_status.value = "not connected";
      printRed("client : iam not connected now");
    }
  }

  Future<void> ListernToEsp() async {
    if (connection_status.value == "connected") {
      {
        espsocket.listen(
          (Uint8List data) async {
            String? resp = String.fromCharCodes(data);
            if (resp.length < 3) {
              printBlue("Client empty");
            } else {
              await Future.delayed(Duration(seconds: 5));
              new_word.value = resp;
              printBlue("Client $resp");
              await speakmanager.speak(resp);
            }
          },
          onError: (e) {
            printRed("Client error in listening $e");
          },
          cancelOnError: false,
          onDone: () async {
            // espsocket.destroy();
            printYellow("Client iam don and destroed");
            // await initSocket();
          },
        );
      }
    }
  }

  Future<bool> isespconnected() async {
    return (await espsocket.isEmpty & await espsocket.isEmpty);
  }

  Future<void> waitSeconds(int seconds) async {
    waiting_now.value = true;
    await Future.delayed(Duration(seconds: seconds));
    waiting_now.value = false;

    // code to be executed after waiting for 2 seconds
  }

  @override
  void onInit() async {
    super.onInit();
    speakmanager.onInit();
    await initSocket();
    await ListernToEsp();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    espsocket.destroy();
    EspManager().dispose();
  }
}
