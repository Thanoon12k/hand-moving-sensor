import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/tts_controller.dart';

class EspManager extends GetxController {
  String? ipaddress;
  late Timer myTimer;

  List<String> AppStates = ["idle",'waiting_esp_connect', 'gettingdata','speaking', 'talking'];
  RxString current_state = "idle".obs;
  Text2SpeechManager speakmanager = Text2SpeechManager();
  RxString mode = "idle".obs;
  RxString hand_text = "unknown".obs;
  RxBool waiting_now = false.obs;
  RxBool connection_status = false.obs;
  late Socket espsocket;

void update_state(index){
  
}


  Future<void> initSocket() async {
    try {
      waiting_now.value = true;
      if (ipaddress == null) {
        throw Exception(['mo ip address']);
      }
      espsocket = await Socket.connect(ipaddress, 80,
          timeout: const Duration(minutes: 5));
      waiting_now.value = false;
      connection_status.value = true;
      debugPrint("client : iam  connected to  $ipaddress");
    } catch (e) {
      waiting_now.value = false;
      connection_status.value = false;
      debugPrint("conn err :$e");
      debugPrint("client : iam not connected to  $ipaddress");
    }
  }

  Future<void> ListernToEsp() async {
    if (connection_status.value == "connected") {
      {
        espsocket.listen(
          (Uint8List data) async {
            String? resp = String.fromCharCodes(data);
            if (resp.length < 3) {
              debugPrint("Client empty");
            } else {
              await Future.delayed(Duration(seconds: 5));
              hand_text.value = resp;
              debugPrint("Client $resp");
              await speakmanager.speak(resp);
            }
          },
          onError: (e) {
            debugPrint("Client error in listening $e");
          },
          cancelOnError: false,
          onDone: () async {
            // espsocket.destroy();
            debugPrint("Client iam don and destroed");
            // await initSocket();
          },
        );
      }
    }
  }

  void handleNewWord(String sender, val) {
    if (sender == "espmanager" && mode.value == "esp") {}
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
