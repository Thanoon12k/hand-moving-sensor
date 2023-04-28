import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TextToSpeechController extends GetxController {
  final RxString mytext = "text to speach start".obs;
  final FlutterTts flutterTts = FlutterTts();

  Future speak(String newVoiceText,
      {double volume = 10, double rate = 0.5, double pitch = 1.0}) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (newVoiceText != null) {
      await flutterTts.speak(newVoiceText);
    }
  }
}
