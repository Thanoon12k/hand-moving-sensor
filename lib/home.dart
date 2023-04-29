import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controllers.dart';
import 'package:wifi/wifi.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Text2Speech tts = Text2Speech();

  final Speech2TExt stt = Speech2TExt();

  final ESPStream espgenrate = ESPStream();

  final TextEditingController _displayed_text_con = TextEditingController();
  bool _is_listining = false;
  bool _is_waiting = false;
  bool _talkstopped = false;
  String button_text = "no text";

  Color button_color = Colors.blueAccent;

  void _talkPress() {
    _talkstopped = !_talkstopped;
    setState(() {});
  }

  void on_off_press() async {
    await espgenrate.handleConnection();
    if (espgenrate.is_connected) {
      button_color = Colors.blueAccent;
    } else {
      button_color = Colors.orangeAccent;
    }

    setState(() {});
  }

  void _handPress() {
    if (_is_listining) {
      // espgenrate.stopGenerator();
      // espgenrate.removeListener(() {});

      _is_listining = false;
    } else {
      _is_listining = true;
    }

    setState(() {});
  }

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
        body: Column(
          children: [
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
                child: StreamBuilder<String>(
              stream: espgenrate.generateStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return !espgenrate.is_connected
                      ? const Center(
                          child: Image(image: AssetImage("images/off.PNG")))
                      : TextContainer(
                          got_text: snapshot.data.toString(),
                        );
                } else {
                  return const TextContainer(
                    got_text: "NO Data",
                  );
                }
              },
            )),
            Expanded(
                child: Container(
              child: Visibility(
                  visible: espgenrate.is_waiting,
                  child: CircularProgressIndicator()),
            )),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: IconButton(
                        icon: Icon(
                          Icons.mic,
                          color: button_color,
                          size: 30,
                        ),
                        onPressed: () {
                          _talkPress();
                        }),
                  ),
                  ButtonText(color: button_color, button_text: "TALK"),
                ],
              ),
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: IconButton(
                          icon: Icon(
                            Icons.waving_hand_outlined,
                            color: button_color,
                            size: 30,
                          ),
                          onPressed: () {
                            _handPress();
                          })),
                  ButtonText(color: button_color, button_text: "MOVE HAND"),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: IconButton(
                        icon: Icon(
                          Icons.online_prediction_rounded,
                          color: button_color,
                          size: 30,
                        ),
                        onPressed: () {
                          on_off_press();
                        }),
                  ),
                  ButtonText(color: button_color, button_text: "ON / OFF"),
                ],
              ),
            ]),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  const ButtonText({
    super.key,
    required this.color,
    required this.button_text,
  });

  final Color color;
  final String button_text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: DefaultTextStyle(
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        child: Text(button_text),
      ),
    );
  }
}

class TextContainer extends StatelessWidget {
  const TextContainer({
    super.key,
    required this.got_text,
  });

  final String got_text;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          got_text,
          style: TextStyle(
            fontSize: 26,
            color: Colors.purple,
            fontWeight: FontWeight.w700,
            decorationColor: Colors.purple,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }
}
