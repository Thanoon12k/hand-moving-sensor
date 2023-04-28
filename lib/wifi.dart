import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'home.dart';

class WifiScreen extends StatelessWidget {
  WifiScreen({super.key});
  final ConnectionManager connectionManager = Get.put(ConnectionManager());
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
              controller: connectionManager.txtcon,
              decoration: const InputDecoration(
                hintText: "0000.0000.0000.0000 ",
                helperText: "Enter ESP32 IP Address ",
                icon: Icon(Icons.key),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Obx(
              () => ElevatedButton(
                onPressed: () async {
                  await connectionManager.updateConnectionStatus();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: connectionManager.is_connected.value
                        ? Colors.lightBlue
                        : Colors.orangeAccent),
                child: const Icon(
                  Icons.wifi,
                  size: 150,
                ),
              ),
            ),
          ),
          Obx(
            () => Container(
                padding: EdgeInsets.all(30),
                child: Text(
                  connectionManager.connection_status.value,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w700),
                )),
          )
        ],
      ),
    );
  }
}
