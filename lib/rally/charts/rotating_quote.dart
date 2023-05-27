import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vine_habits/layout/adaptive.dart';

class RotatingQuoteWidget extends StatefulWidget {
  RotatingQuoteWidget({
    Key? key,
    required this.quotes,
  }) : super(key: key);

  final List<String> quotes;

  @override
  State<RotatingQuoteWidget> createState() => _RotatingQuoteWidgetState();
}

class _RotatingQuoteWidgetState extends State<RotatingQuoteWidget> {
  int _currentIndex = 0;

  List<String> get _quotes => widget.quotes;
  final animatedTextKit = AnimatedTextKit(
    totalRepeatCount: 1,
    animatedTexts: [
      TypewriterAnimatedText(
        "",
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        speed: const Duration(milliseconds: 75),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _updateQuote();
  }

  Key _animatedTextKey = UniqueKey();

  void _rotateQuote() {
    setState(() {
      debugPrint("Updating quote to ${_quotes[_currentIndex]}");

      _currentIndex = (_currentIndex + 1) % _quotes.length;
      _animatedTextKey = UniqueKey();
    });
  }

  void _updateQuote() {
    debugPrint("Updating quote to ${_quotes[_currentIndex]}");
    animatedTextKit.animatedTexts[0] = TypewriterAnimatedText(
      _quotes[_currentIndex],
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      speed: const Duration(milliseconds: 75),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: _rotateQuote, // Update: Pass _rotateQuote as onTap handler
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: isDesktop
                ? const EdgeInsets.all(100)
                : const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: AnimatedTextKit(
              totalRepeatCount: 1,
              key: _animatedTextKey,
              animatedTexts: [
                TypewriterAnimatedText(
                  _quotes[_currentIndex],
                  textStyle: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 75),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
