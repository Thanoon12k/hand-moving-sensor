import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class Speech2TextManager extends GetxController {
  late SpeechToText stt;
  RxString language = "العربية".obs;
  String _lang_id = "العربية";
  RxString talk_text = "talk initial".obs;
  RxBool is_listining = false.obs;

  void stt_init() {
    stt.initialize(
      
      onStatus: (s) {
        talk_text.value = s.toString();
        debugPrint("sttus ${s.toString()}");
      },
      onError: (e) {
        debugPrint("talk error : $e");
      },
    );
  }

  Future<bool> StartListining() async {
    
    if (stt.isAvailable) {
      if (!is_listining.value) {
        stt.listen(
         
          onResult: (result) {
            talk_text.value = result.recognizedWords;
            is_listining.value = true;
            debugPrint("res ${result.toString()}");
          },
        );
      } else {
        is_listining.value = false;
        stt.stop();
      }
    }
    return true;
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

  void toggleLanguage()  {
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
