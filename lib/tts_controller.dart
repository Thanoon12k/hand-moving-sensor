import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Text2SpeechManager extends GetxController {
  final RxString mytext = "text to speach start".obs;
  late FlutterTts ftts;
  @override
  void onInit() async {
    // TODO: implement onInit
    ftts = FlutterTts();
    ftts.awaitSpeakCompletion(true);
    await ftts.setVolume(1);
    await ftts.setSpeechRate(0.5);
    await ftts.setPitch(1);
    super.onInit();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    await ftts.stop();
    super.dispose();
  }

  Future speak(String text,
      {double volume = 1, double rate = 0.5, double pitch = 1.0}) async {
    if (text != null) {
      print("iam speaaking $text");
      
      await ftts.speak(text);
    }
  }

  Future<void> Stop() async {
    await ftts.stop();
  }
}
