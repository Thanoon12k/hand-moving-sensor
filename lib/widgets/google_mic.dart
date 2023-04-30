import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';

import '../stt_controller.dart';
import '../tts_controller.dart';

class GoogleIconButton extends StatefulWidget {
  GoogleIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.controller,
    required this.ttscontroller,
    required this.sttcontroller,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final EspManager controller;
  final Text2SpeechManager ttscontroller;
  final Speech2TextManager sttcontroller;

  @override
  _GoogleIconButtonState createState() => _GoogleIconButtonState();
}

class _GoogleIconButtonState extends State<GoogleIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.8,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _listenPress() async {
    await widget.controller.ListernToEsp();
  }

  void _talkPress() async {
    widget.controller.current_mode.value = "waiting_speak";
    await widget.ttscontroller.speak(widget.controller.new_word.value);
    widget.controller.current_mode.value = "talking";
  }

  void _onTapDown(TapDownDetails details) async {
    debugPrint("button -${widget.text}  clicked");
    if (widget.text == "MOVE HAND") {
      _listenPress();
    } else if (widget.text == "TALK") {
      _talkPress();
    }
    setState(() {
      _isPressed = true;
    });
    if (widget.text == "MOVE HAND") {
    } else {}
    _animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPressed) {
        _onTapDown(details);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _onTapUp(TapUpDetails details) async {
    _timer?.cancel();

    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    _timer?.cancel();
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const iconColor = Colors.blue;
    const iconWeight = FontWeight.w600;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                elevation: 5.0,
                shape: const CircleBorder(),
                color: _isPressed ? Colors.grey[300] : Colors.white,
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: IconButton(
                    icon: Icon(widget.icon),
                    onPressed: () {},
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: iconColor,
              fontSize: 14,
              fontWeight: iconWeight,
            ),
            child: Text(widget.text),
          ),
        ),
      ],
    );
  }
}
