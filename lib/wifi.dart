import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';

import 'home.dart';

class WIFISCREEN extends StatefulWidget {
  @override
  State<WIFISCREEN> createState() => _WIFISCREENState();
}
//  '192.168.43.78'

class _WIFISCREENState extends State<WIFISCREEN> {
  TextEditingController _addtextcon = TextEditingController();

  EspManager espcontroller = Get.find<EspManager>();

  void _connect() async {
    debugPrint('connecting ${_addtextcon.text}');
    espcontroller.ipaddress = _addtextcon.text;
    await espcontroller.initSocket();
    setState(() {});
  }

  void _disconnect() {
    espcontroller.connection_status.value = "disconnected";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: espcontroller.connection_status.value == "connected"
                ? ElevatedButton(
                    onPressed: _disconnect,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text(
                      "Disconnect",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : Container(),
          )
        ],
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Get.to(() => HomeOk())),
      ),
      body: espcontroller.connection_status.value == "connected"
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child:
                        Image.asset("images/bluetooth2.PNG", fit: BoxFit.fill),
                  ),
                  MyText(buttontext: "Connected to ${_addtextcon.text}"),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child:
                        Image.asset("images/bluetooth4.png", fit: BoxFit.cover),
                  ),
                  const MyText(buttontext: "NOT Connected !!"),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addtextcon,
                          decoration: const InputDecoration(
                            helperText: 'Enter ESP ADDRESS',
                            icon: Icon(
                              Icons.key,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: ElevatedButton(
                            onPressed: _connect,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: const Text(
                              'Connect Now',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                    ],
                  ),
                  kDebugMode
                      ? Column(
                          children: [
                            Obx(
                              () => MyText(
                                  buttontext:
                                      "mode ${espcontroller.current_mode.value}"),
                            ),
                            Obx(
                              () => MyText(
                                  buttontext:
                                      "espconniction ${espcontroller.connection_status.value}"),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
    );
  }
}

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    required this.buttontext,
  });

  final String buttontext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        buttontext,
        style: const TextStyle(color: Colors.purple, fontSize: 24),
      ),
    );
  }
}
