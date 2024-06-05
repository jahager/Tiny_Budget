import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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


class DollarTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DollarTextInputFormatter({this.decimalRange = 2}) : assert(decimalRange > 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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
        newValue.text.substring(newValue.text.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (truncated.startsWith("0") && truncated.length > 1 && !truncated.contains(".")) {
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

