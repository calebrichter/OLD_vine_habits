import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RotatingQuoteWidget extends StatefulWidget {
  RotatingQuoteWidget({
    super.key,
    required this.quotes,
  });
  // add constructor that takes a list of quotes as initialization parameter
  final List<String> quotes;
  @override
  State<RotatingQuoteWidget> createState() => _RotatingQuoteWidgetState();
}

// buildSegments needs no equivalent
class _RotatingQuoteWidgetState extends State<RotatingQuoteWidget> {
  int _currentIndex = 0;

  List<String> get _quotes => widget.quotes;
  void _rotateQuote() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _rotateQuote,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            alignment: Alignment.center,
            child: AnimatedTextKit(animatedTexts: [
              TypewriterAnimatedText(_quotes[_currentIndex],
                  textStyle: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  speed: const Duration(milliseconds: 100))
            ]),
          )),
    );
  }
}
