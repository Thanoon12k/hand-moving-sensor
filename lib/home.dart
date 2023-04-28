import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';
import 'package:wifi/widgets/google_mic.dart';
import 'package:wifi/wifi.dart';

// import 'controllers/flutter_stt_con.dart';
// import 'controllers/stt_controller.dart';
// import 'controllers/tts_controller.dart';
import 'controllers/stt_controller.dart';
import 'controllers/tts_controller.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatelessWidget {
  final TextEditingController txtcon = TextEditingController();
  final TextToSpeechController tts = Get.put(TextToSpeechController());
  final SpeachToTextController stt = Get.put(SpeachToTextController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reach To All',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 245, 242, 242),
        appBar: AppBar(
          title: GestureDetector(
            child: Image.asset('images/bluetooth3.png'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WifiScreen()),
            ),
          ),
          actions: const [
            Center(
              child: Text(
                "Reach To All",
                style: TextStyle(
                  fontFamily: AutofillHints.birthdayYear,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            )
          ],
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
        ),
        body: Column(children: [
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.topCenter,
            child: const Text(
              'The World Need Your Voice',
              style: TextStyle(
                fontSize: 25,
                color: Colors.pinkAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 45),
          Container(
            width: 350,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
                  ConnectionManager().new_message.value,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.purple,
                    fontWeight: FontWeight.w700,
                    decorationColor: Colors.purple,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(child: Text("")),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleIconButton(
                buttonIcon: const Icon(Icons.mic),
                buttonText: "TALK",
                handword: "error",
              ),
              GoogleIconButton(
                buttonIcon: const Icon(Icons.waving_hand_outlined),
                buttonText: "MOVE HAND",
                handword: "Hello",
              )
            ],
          ),
          const SizedBox(
            height: 40,
          )
        ]),
      ),
    );
  }
}

class icon_button extends StatelessWidget {
  const icon_button({
    super.key,
    required this.buttonicon,
    required this.buttontext,
  });

  final Icon buttonicon;
  final String buttontext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: IconButton(icon: buttonicon, onPressed: () {}),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Text(buttontext),
        ),
      ],
    );
  }
}
