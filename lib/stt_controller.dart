import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class Speech2TextManager extends GetxController {
  late SpeechToText stt;
  RxString language = "العربية".obs;
  String _lang_id = "العربية";
  RxString talk_text = "".obs;
  RxBool is_listining = false.obs;
  RxBool is_pressed_now = false.obs;

  void stt_init() {
    stt.initialize(
      onError: (e) {
        is_listining = false.obs;
        debugPrint("talk to text not inite  -$e");
      },
    );
  }

  Future StartListining() async {
    try {
      if (stt.isAvailable) {
        await stt.listen(
          
          onResult: (result) {
            is_listining.value = true;
            talk_text.value = result.recognizedWords;
            if (result.finalResult) {
              print('iam in finalr result -${result.recognizedWords}');
            }
            debugPrint("res ${result..toString()}");
          },
        );
      }
    } catch (e) {
      debugPrint('listining exited : $e');
      is_listining.value = false;
    }
  }

  void StopListining() async {
    await stt.stop();
  }

  void _checkPermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }
    print("permision < ${status} >");
  }

  void toggleLanguage() {
    if (_lang_id == "en-us") {
      _lang_id = "ar-eg";
      language.value = "العربية";
    } else {
      _lang_id = "en-us";
      language.value = "English";
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    _checkPermission();
    stt = SpeechToText();
    stt_init();

    super.onInit();
  }
}
