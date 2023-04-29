import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class FreshStream {
  late StreamController mystreamcon = StreamController();
  late Stream mystream = mystreamcon.stream;

  void add() {
    mystreamcon.sink.add(2);
  }
}

class ESPStream extends GetxController {
  bool is_connected = false;
  bool is_listening = false;
  bool is_error = false;
  bool is_waiting = false;
  Timer? _subscription;
  late Socket espsocket;
  final _controller = StreamController<String>();

  handleConnection() async {
    if (!is_connected) {
      try {
        is_waiting = true;
        espsocket = await Socket.connect("192.168.43.78", 80,
            timeout: Duration(seconds: 3));
        is_connected = true;
        is_error = false;
        is_waiting = false;
      } catch (e) {
        is_waiting = false;
        is_error = true;

        debugPrint("conn error > $e");
      }
    } else {
      await espsocket.close();
      is_connected = false;
    }
  }

  generateStream() {
    if (is_connected) {
      _subscription = Timer.periodic(const Duration(seconds: 1), (timer) async {
        try {
          final response =
              await espsocket.transform(StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(utf8.decode(data));
            },
          )).first;
          _controller.add(response.toString());
        } catch (e) {
          debugPrint('Error: $e');
        }
      });
      return _controller.stream;
    } else {}
  }

  void stopGenerator() {
    _subscription?.cancel();

    _subscription = null;
  }
}

class Text2Speech {
  final FlutterTts flutterTts = FlutterTts();
  Future speak(String message) async {
    await flutterTts.speak(message);
  }
}

class Speech2TExt extends GetxController {
  String lastWords = "";
  String lastStatus = "";
  String lasterror = "";
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  bool is_available = false;
  bool is_speech = false;
  RxString diplayed_text = "this is controller displayed text".obs;
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  late stt.SpeechToText speech;

  @override
  void onInit() async {
    super.onInit();
    await initSpeechState();
  }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onStatus: ((status) => lastStatus = status),
      );
      if (hasSpeech) {
        _localeNames = await speech.locales();
        diplayed_text.value = "inite complete";

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }

      is_speech = hasSpeech;
    } catch (e) {
      lasterror = 'Speech recognition failed: ${e.toString()}';
      is_speech = false;
    }
  }

  void startListening() {
    lastWords = '';

    // Note that `listenFor` is the maximum, not the minimun, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  void stopListening() {
    speech.stop();

    level = 0.0;
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    this.level =
        level / 100; // update the level variable with the new level value
  }

  void resultListener(SpeechRecognitionResult result) {
    lastWords = "${result.recognizedWords} - ${result.finalResult}";
    diplayed_text.value = lastWords;
  }
}
