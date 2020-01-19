// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui';

import 'package:analog_clock/clock_face.dart';
import 'package:analog_clock/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnClockFace extends ClockFace {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnClockFace({
    @required this.color,
    @required this.thickness,
    @required this.majorTickThickness,
  })  : assert(color != null),
        assert(thickness != null),
        assert(majorTickThickness != null),
        super(
        color: color,
        tickThickness: thickness,
        majorTickThickness: majorTickThickness,
      );

  /// How thick the ticks of the clock should be drawn, in logical pixels.
  final double majorTickThickness;
  final double thickness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _ClockPainter(
            majorTickWidth: majorTickThickness,
            minorTickWidth: thickness,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _ClockPainter extends CustomPainter {
  _ClockPainter({
    @required this.majorTickWidth,
    @required this.minorTickWidth,
    @required this.color,
  })  : assert(majorTickWidth != null),
        assert(minorTickWidth != null),
        assert(color != null);

  double majorTickWidth;
  double minorTickWidth;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center + centerOffset;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = minorTickWidth;

    final thickLinePaint = Paint()
      ..color = color
      ..strokeWidth = majorTickWidth;

    final textStyle = ParagraphStyle(textAlign: TextAlign.center, textDirection: TextDirection.ltr, fontFamily: 'monospace', fontSize: 24);

    for(int i = 60; i > 0; i--) {
      var positionRim = center + Offset(math.cos(i * clockTickAngle), math.sin(i * clockTickAngle)) * size.shortestSide * 0.48;
      var positionInner = center +
          Offset(math.cos(i * clockTickAngle), math.sin(i * clockTickAngle)) *
              size.shortestSide * 0.46;


      // Paints the hour numbers and ticks for the clock
      if(i % 5 == 0){
        positionInner = center + Offset(math.cos(i * clockTickAngle), math.sin(i * clockTickAngle)) * size.shortestSide * 0.44;
        var positionText = center + Offset(math.cos(i * clockTickAngle - perpAngle), math.sin(i * clockTickAngle - perpAngle)) * size.shortestSide * 0.4;
        ParagraphBuilder paragraphBuilder = ParagraphBuilder(textStyle);

        // paragraphBuilder.addText((i ~/ 5).toString());
        Paragraph p = paragraphBuilder.build();
        if((i ~/ 5) < 10) {
          p.layout(ParagraphConstraints(width: 16));
        } else {
          p.layout(ParagraphConstraints(width: 32));
        }
        canvas.drawParagraph(p, positionText - Offset(p.width / 2, 14));
        canvas.drawLine(positionRim, positionInner, thickLinePaint);
      } else {
        canvas.drawLine(positionRim, positionInner, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_ClockPainter oldDelegate) {
    return oldDelegate.minorTickWidth != minorTickWidth ||
        oldDelegate.majorTickWidth != majorTickWidth ||
        oldDelegate.color != color;
  }
}
