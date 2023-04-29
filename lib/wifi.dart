import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';
import 'home.dart';

class WifiScreen extends StatefulWidget {
  WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  TextEditingController addresstext = TextEditingController();

  final ESPStream espgenrate = ESPStream();

  String _connection_status = "not connectd";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: addresstext,
              decoration: const InputDecoration(
                hintText: "0000.0000.0000.0000 ",
                helperText: "Enter ESP32 IP Address ",
                icon: Icon(Icons.key),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: ElevatedButton(
              onPressed: () {
                if (espgenrate.is_connected) {
                  espgenrate.is_connected = false;
                  _connection_status = "not connected";
                } else {
                  espgenrate.is_connected = true;
                  _connection_status = "ESP is connected enjoy";
                }
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: espgenrate.is_connected
                      ? Colors.lightBlue
                      : Colors.orangeAccent),
              child: const Icon(
                Icons.wifi,
                size: 150,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(30),
              child: Text(
                _connection_status,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              )),
        ],
      ),
    );
  }
}
