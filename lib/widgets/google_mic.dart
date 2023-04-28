import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi/controller.dart';

import '../controllers/stt_controller.dart';
import '../controllers/tts_controller.dart';

class GoogleIconButton extends StatefulWidget {
  GoogleIconButton({
    Key? key,
    required this.buttonIcon,
    required this.buttonText,
    required this.handword,
  }) : super(key: key);

  final Icon buttonIcon;
  final String buttonText;
  final String handword;

  @override
  _GoogleIconButtonState createState() => _GoogleIconButtonState();
}

class _GoogleIconButtonState extends State<GoogleIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextToSpeechController tts = Get.put(TextToSpeechController());
  final SpeachToTextController stt = Get.put(SpeachToTextController());

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

  void _onTapDown(TapDownDetails details) async {
    stt.diplayed_text.value = "say hello .";
    setState(() {
      _isPressed = true;
    });
    if (widget.buttonText == "MOVE HAND") {
      String _word = (await ConnectionManager().getoneword());

      tts.speak(_word);
    } else {
      !stt.is_speech || stt.speech.isListening ? null : stt.startListening();
    }
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
    stt.speech.isListening ? stt.stopListening() : null;
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
                    icon: widget.buttonIcon,
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
            child: Text(widget.buttonText),
          ),
        ),
      ],
    );
  }
}
