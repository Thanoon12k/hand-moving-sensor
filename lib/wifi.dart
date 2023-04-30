// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class WIFISCREEN extends StatefulWidget {
  WIFISCREEN({required this.connecttd_status});
  bool connecttd_status;

  @override
  State<WIFISCREEN> createState() => _WIFISCREENState();
}

class _WIFISCREENState extends State<WIFISCREEN> {
  TextEditingController addresscon = TextEditingController();
  bool is_waiting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.off(() => HomeScreen())),
      ),
      body: widget.connecttd_status
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child:
                        Image.asset("images/bluetooth2.PNG", fit: BoxFit.fill),
                  ),
                  const MyText(buttontext: "NOT Connected !!"),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child:
                        Image.asset("images/bluetooth4.png", fit: BoxFit.cover),
                  ),
                  const MyText(buttontext: "You Are Connected enjoy"),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: addresscon,
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
                  is_waiting
                      ? Container(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}
