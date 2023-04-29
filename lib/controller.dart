import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EspManager extends GetxController {
  RxString mode = "idle".obs;
  RxBool waiting_now = false.obs;
  late Socket espsocket;

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

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

  late Future waitintime = Future.delayed(const Duration(seconds: 2));
  Stream<String?> GetNextWord() async* {
    await for (var mod in mode.stream) {
      if (mod == "idle") {
        yield "idle";
      } else if (mod == "talking") {
        yield "talking now";
      } else if (mod == "esp") {
        mode.value = "esp";
        waiting_now.value = true;
        var _espconnected = await isespconnected();
        waiting_now.value = false;
        // while (_espconnected) {
        waiting_now.value = true;
        await waitintime;
        String nextword = await GetEspData();
        waiting_now.value = false;
        yield nextword;
        // }
      } else {
        yield "null";
      }
    }
  }

  Future<String> GetEspData() async {
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
}
