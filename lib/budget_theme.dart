import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ButtonStyle roundSquareStyle = OutlinedButton.styleFrom(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))));

class OutlineText extends StatelessWidget {
  const OutlineText(this.text, {super.key, this.fontSize = 42, this.outlineWidth = 4, this.withGradient = false, this.color = const [] });
  final String text;
  final double outlineWidth;
  final double fontSize;
  final bool withGradient;
  final List<Color> color;
  @override
  Widget build(BuildContext context) {
    List<Color> colors = color.toList();
    switch (colors.length){
      case 0:
        if (withGradient){
          colors.add(Theme.of(context).colorScheme.primary);
          colors.add(Theme.of(context).colorScheme.inversePrimary);
        } else {
          colors.add(Theme.of(context).colorScheme.inversePrimary);
          colors.add(Theme.of(context).colorScheme.inversePrimary);
        }
      break;
      case 1:
        colors.add(colors[0]);
        break;
      default:
        break;
    }

    return Stack(children: [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = outlineWidth
            ..color = Colors.black,
        ),
      ),
      ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(colors: colors).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: colors[0],
          ),
        ),
      )
    ]);
  }
}

class RoundBoxContainer extends StatelessWidget {
  const RoundBoxContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
      border:
          Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ));
  }
}

// Prevents weird amount/dollar inputs
class DollarTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DollarTextInputFormatter({this.decimalRange = 2}) : assert(decimalRange > 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (newValue.text == ".") {
      truncated = "0.";
      newSelection = newValue.selection.copyWith(
        baseOffset: min(truncated.length, truncated.length + 1),
        extentOffset: min(truncated.length, truncated.length + 1),
      );
    } else if (newValue.text.contains(".") &&
        newValue.text.substring(newValue.text.indexOf(".") + 1).length >
            decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (truncated.startsWith("0") &&
        truncated.length > 1 &&
        !truncated.contains(".")) {
      truncated = truncated.substring(1);
    } else {
      int indexOfDecimal = truncated.indexOf(".");
      if (indexOfDecimal != -1) {
        int lengthAfterDecimal = truncated.length - indexOfDecimal - 1;
        if (lengthAfterDecimal > decimalRange) {
          truncated = truncated.substring(0, indexOfDecimal + decimalRange + 1);
        }
      }
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
