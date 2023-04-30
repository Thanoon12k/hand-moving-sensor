import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/tts_controller.dart';

class EspManager extends GetxController {
  late Timer myTimer;
  Text2SpeechManager speakmanager = Text2SpeechManager();
  late Socket espsocket;
  List<String> appstates = ['idle', 'getting_data', 'waiting_speak', 'talking'];
  List<String> cccconectionstates = [
    'not_connected',
    'waiting_connect',
    'connected'
  ];
  RxString current_mode = "idle".obs;
  String? ipaddress;
  RxString connection_status = "not_connected".obs;
  RxString new_word = 'word initital'.obs;

  void update_state(index) {}

  Future<void> initSocket() async {
    try {
      if (ipaddress == null) {
        throw Exception(['mo ip address']);
      }
      connection_status.value = "waiting_connect";
      espsocket = await Socket.connect(ipaddress, 80,
          timeout: const Duration(seconds: 4));
      connection_status.value = "connected";
      debugPrint("client : iam  connected to  $ipaddress ");
    } catch (e) {
      connection_status.value = "not_connected";
      debugPrint("client :i can't connected to  $ipaddress -$e");
    }
  }

  Future<void> ListernToEsp() async {
    current_mode.value = "getting_data";

    if (connection_status.value != "connected") {
      current_mode.value = "idle";
      debugPrint(
          "can't readdata from $ipaddress not connected -${connection_status.value}");
    } else {
      espsocket.listen(
        (Uint8List data) async {
          if (current_mode.value == "idle" || current_mode.value == "talking") {
            throw Exception(['lisining exited to idle mode']);
          }
          String resp = String.fromCharCodes(data);
          if (resp.length < 3) {
            debugPrint("Client data is to short -$resp");
          } else {
            new_word.value = resp;
            debugPrint("i got new data -$resp");
          }
        },
        onError: (e) {
          debugPrint("Client error in geting data -$e");
          espsocket.destroy();
        },
        cancelOnError: true,
        onDone: () async {
          current_mode.value = "idle";
          espsocket.destroy();
          debugPrint("Client iam done must disconnected now and destroed");
        },
      );
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await initSocket();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    espsocket.destroy();
    EspManager().dispose();
  }
}
