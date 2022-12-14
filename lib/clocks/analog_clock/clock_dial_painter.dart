import 'dart:math';

import 'package:flutter/material.dart';

class ClockDialPainter extends CustomPainter {
  late final clockText;
  final bool showTicks;

  final hourTickMarkLength = 10.0;
  final minuteTickMarkLength = 5.0;

  final hourTickMarkWidth = 3.0;
  final minuteTickMarkWidth = 1.5;

  final Paint tickPaint = Paint()..color = Colors.black;
  late final TextPainter textPainter;
  late TextStyle textStyle;

  final romanNumeralList = [
    'XII',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI'
  ];

  ClockDialPainter(
      {this.clockText = ClockText.arabic, this.showTicks = false}) {
    textStyle = const TextStyle(
      color: Colors.black,
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  // a function that takes the screen size and calculates a font size between 12 and 24
  double calculateFontSize(Size size) {
    final fontSize = size.width / 10;
    if (fontSize > 24) {
      return 24;
    } else if (fontSize < 12) {
      return 12;
    } else {
      return fontSize;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final fontSizeBasedUponWidth = size.width / 8;

    textStyle = textStyle.copyWith(fontSize: calculateFontSize(size));

    var tickMarkLength;
    final angle = 2 * pi / 60;
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);
    for (var i = 0; i < 60; i++) {
      tickMarkLength = i % 5 == 0 ? hourTickMarkLength : minuteTickMarkLength;
      tickPaint.strokeWidth =
          i % 5 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      if (showTicks)
        canvas.drawLine(Offset(0.0, -radius),
            Offset(0.0, -radius + tickMarkLength), tickPaint);

      if (i % 5 == 0) {
        canvas.save();
        var spaceFromSize = showTicks ? 18 + tickMarkLength : 18;
        canvas.translate(0.0, -radius + spaceFromSize);
        textPainter.text = new TextSpan(
          text: clockText == ClockText.roman
              ? '${romanNumeralList[i ~/ 5]}'
              : '${i == 0 ? 12 : i ~/ 5}',
          style: textStyle,
        );

        canvas.rotate(-angle * i);
        textPainter.layout();
        textPainter.paint(canvas,
            Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
        canvas.restore();
      }
      canvas.rotate(angle);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum ClockText { roman, arabic }
