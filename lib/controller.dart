import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RandomIntStreamGenerator {
  Stream<int> generateStream() {
    final controller = StreamController<int>();
    final random = Random();
    Timer.periodic(Duration(seconds: 1), (timer) {
      controller.add(random.nextInt(100));
    });

    return controller.stream;
  }
}

class ESPStream {
  Stream<String> generateStream() {
    final _controller = StreamController<String>();
    final random = Random();
    Timer.periodic(Duration(seconds: 1), (timer) async {
      try {
        final socket = await Socket.connect("192.168.43.78", 80);
        final response = await socket.transform(StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(utf8.decode(data));
          },
        )).first;
        _controller.add(response.toString());
      } catch (e) {
        print('Error: $e');
      }
    });

    return _controller.stream;
  }
}

class ConnectionManager extends GetxController {
  TextEditingController txtcon = TextEditingController(text: "text to send");
  late Socket espsocket;
  final ipaddress = "192.168.43.78";
  RxBool is_connected = false.obs;

  RxBool is_new_data = false.obs;
  RxBool wait_connection = false.obs;
  RxString new_message = "none".obs;
  RxString connection_status = "not connected".obs;

  StreamController<String> _messageController =
      StreamController<String>.broadcast();

  Stream<String> get messageStream => _messageController.stream;

  Future<void> updateConnectionStatus() async {
    if (is_connected.value) {
      await disConnect();
    } else {
      await connect();
    }
  }

  Future<void> connect() async {
    try {
      // connect to esp32
      wait_connection.value = true;
      espsocket = await Socket.connect(ipaddress, 80,
          timeout: const Duration(seconds: 5));
      wait_connection.value = false;
      connection_status.value = "connectd now enjoy";
      is_connected.value = true;
    } catch (e) {
      wait_connection.value = false;
      debugPrint('Error: $e');
    }
  }

  Future<void> disConnect() async {
    try {
      //disconnect from esp32
      espsocket.close();
      is_connected.value = false;
      connection_status.value = "not connectd";
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> getMessage(String message) async {
    try {
      // send message to ESP32
      final socket = await Socket.connect(ipaddress, 80);
      socket.write(message);
      await socket.flush(); // Flush the socket to ensure the message is sent
      final response = await socket.transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(utf8.decode(data));
          },
        ),
      ).first;
      socket.close();
      _messageController.add(response.toString());
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<RxBool> sendMessage(message) async {
    try {
      espsocket.write(message);
      espsocket.close();
      return true.obs;
    } catch (e) {
      return false.obs;
    }
  }

  Future<String> chat(data) async {
    try {
      final socket = await Socket.connect("192.168.43.78", 80);
      print('socket : ');
      socket.write(data);
      final response = await socket.transform(StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(utf8.decode(data));
        },
      )).first;
      socket.close();
      return response.toString();
    } catch (e) {
      print('Error: $e');
      return "error : $e";
    }
  }

  Future<String> getoneword() async {
    try {
//get the message from esp32
      final socket = await Socket.connect(ipaddress, 80);
      final response = await socket.transform(StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(utf8.decode(data));
        },
      )).first;
      new_message.value = response.toString();
      socket.close();
      return response.toString();
    } catch (e) {
      debugPrint('Error: $e');
      return "error : $e";
    }
  }
}
