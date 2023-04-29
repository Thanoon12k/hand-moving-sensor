import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EspManager extends GetxController {
  late Future waitintime = Future.delayed(const Duration(seconds: 2));
  RxString new_word = "no word".obs;
  RxString mode = "idle".obs;
  RxBool waiting_now = false.obs;
  late Socket espsocket;
  StreamController<String?> espscon = StreamController();

  late Stream<String?> mydatastream = espscon.stream.asBroadcastStream();

  void _initSocket() async {
    try {
      waiting_now.value = true;
      espsocket = await Socket.connect('192.168.43.78', 80,
          timeout: const Duration(seconds: 3));
      waiting_now.value = false;
      debugPrint(' connecting ok: $espsocket');
    } catch (e) {
      debugPrint('no connecting to socket: $e');
    }
  }

  Future<String> GetEspData() async {
    waiting_now.value = true;
    await waitintime;
    waiting_now.value = false;

    var randint = Random().nextInt(10);
    espscon.sink.add((randint * 3).toString());
    debugPrint(randint.toString());
    new_word.value = "rand ${randint.toString()}";
    if (mode == "esp" && false==true) {
      
      GetEspData();
    }
    return "rand ${randint.toString()}";

    try {
      var new_word = await espsocket.transform(StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(utf8.decode(data));
        },
      )).first;
      return new_word.toString();
    } catch (e) {
      debugPrint('Error: $e');
      return "err ${Random().nextInt(100).toString()} : $e";
    }
  }

  Future<bool> isespconnected() async {
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }
}
