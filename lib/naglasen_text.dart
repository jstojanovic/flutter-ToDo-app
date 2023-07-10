import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double strokeWidth;
  final Color outlineColor;

  const OutlinedText({
    Key? key,
    required this.text,
    this.style = const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
    this.strokeWidth = 0.3,
    this.outlineColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(-strokeWidth, -strokeWidth),
          child: Text(
            text,
            style: style.copyWith(color: outlineColor),
          ),
        ),
        Transform.translate(
          offset: Offset(strokeWidth, strokeWidth),
          child: Text(
            text,
            style: style.copyWith(color: outlineColor),
          ),
        ),
        Text(
          text,
          style: style,
        ),
      ],
    );
  }
}
