import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EspManager extends GetxController {
  late Future waitintime = Future.delayed(const Duration(seconds: 2));
  late Timer myTimer;
  RxString mode = "unknown".obs;
  RxString new_word = "unknown".obs;
  RxBool waiting_now = false.obs;
  RxString connection_status = "not connected".obs;
  late Socket espsocket ;

  Future _initSocket() async {
    try {
      waiting_now.value = true;
      espsocket = await Socket.connect('192.168.43.78', 80,
          timeout: const Duration(seconds: 3));
      waiting_now.value = false;
      connection_status.value = "connected";
    } catch (e) {
      waiting_now.value = false;
      connection_status.value = "not connected";
    }
  }

  Future<void> GetEspData() async {
    if (connection_status.value == "not connected") {
      await _initSocket();
    }
    var randint;
    await Timer.periodic(Duration(seconds: 1), (timer) async {
      randint = Random().nextInt(100);

      if (mode.value == "idle") {
        new_word.value = "idle";
        timer.cancel();
      } else if (mode.value == "talking") {
        timer.cancel();
        new_word.value = "talking now";
      } else if (mode.value == "esp") {
        await GetNextWord();
      }
      // debugPrint("$mode $randint");
    });
  }

  Future<String?> GetNextWord() async {
    try {
    
      final response = await espsocket.transform(StreamTransformer.fromHandlers(
        handleData: (data, _) {
          new_word.value = utf8.decode(data);
        },
      )).first;
      connection_status.value = "connected";
    } catch (e) {
      connection_status.value = "not connected";

      debugPrint('Error: $e');
      return "err ${Random().nextInt(100).toString()} : $e";
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
  void onInit() {
    super.onInit();

    _initSocket();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    espsocket.destroy();
    EspManager().dispose();
  }
}
