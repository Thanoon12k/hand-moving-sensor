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

  RxString current_mode = "idle".obs;
  String? ipaddress;
  RxString connection_status = "not_connected".obs;
  RxString new_word = ''.obs;

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
    try {
      current_mode.value = "esp";

      if (connection_status.value != "connected") {
        current_mode.value = "idle";
        debugPrint(
            "can't readdata from $ipaddress not connected -${connection_status.value}");
      } else {
        espsocket.listen(
          (Uint8List data) async {
            if (current_mode.value == "idle" ||
                current_mode.value == "talking") {
              throw Exception(['lisining exited to idle mode']);
            }
            String resp = String.fromCharCodes(data);
            if (resp.length > 3) {
              new_word.value = resp;
              await speakmanager.speak(resp.toString());
              debugPrint("i got new data -$resp");
            } else {
              debugPrint("Client data is to short -$resp");
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
    } catch (e) {
      debugPrint("Exception in listening: $e");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await initSocket();
    speakmanager.initSpeaktoText();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    espsocket.destroy();
    EspManager().dispose();
  }
}
