import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EspManager extends GetxController {
  late Future waitintime = Future.delayed(const Duration(seconds: 2));
  late Timer myTimer;
  RxString mode = "unknown".obs;
  RxString new_word = "unknown".obs;
  RxBool waiting_now = false.obs;
  late Socket espsocket;
  StreamController<String?> espscon = StreamController();
  late Stream<String?> mydatastream = espscon.stream.asBroadcastStream();
  late StreamSubscription consolsubscriber;
  late StreamSubscription textsubscriber;
  void _initSocket() async {
    try {
      waiting_now.value = true;
      espsocket = await Socket.connect('192.168.43.78', 80,
          timeout: const Duration(seconds: 3));
      waiting_now.value = false;
      debugPrint(' connecting ok: $espsocket');
    } catch (e) {
      waiting_now.value = false;
      debugPrint('no connecting to socket: $e');
    }
  }

  Future<void> GetEspData() async {
    var randint;
    await Timer.periodic(Duration(seconds: 3), (timer) async {
      randint = Random().nextInt(100);
     
      if (mode.value == "idle") {
        new_word.value = "idle";
        timer.cancel();
      } else if (mode.value == "talking") {
        timer.cancel();
        new_word.value = "talking now";
      } else if (mode.value == "esp") {
        new_word.value = randint.toString();
      }
       debugPrint("$mode $randint");
      
    });

    // try {
    //   var new_word = await espsocket.transform(StreamTransformer.fromHandlers(
    //     handleData: (data, sink) {
    //       sink.add(utf8.decode(data));
    //     },
    //   )).first;
    //   return new_word.toString();
    // } catch (e) {
    //   debugPrint('Error: $e');
    //   return "err ${Random().nextInt(100).toString()} : $e";
    // }
  }

  Future<bool> isespconnected() async {
    return true;
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
    consolsubscriber = mydatastream.listen((event) {
      debugPrint("event > ${event.toString()}");
    });
    _initSocket();
  }
}
