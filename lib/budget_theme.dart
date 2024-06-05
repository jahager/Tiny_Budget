import 'package:flutter/material.dart';

final ButtonStyle roundSquareStyle = OutlinedButton.styleFrom(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)))
);

class OutlineText extends StatelessWidget {
  const OutlineText(this.text, {this.fontSize = 42});
  final String text;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = Colors.black,
        ),
      ),
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    ]);
  }
}

class RoundBoxContainer extends StatelessWidget {
  const RoundBoxContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary,
    width: 2
    ),
    borderRadius: BorderRadius.circular(16.0),
    ));
  }
}

