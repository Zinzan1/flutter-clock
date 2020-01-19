// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:analog_clock/constants.dart';
import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: size,
            lineWidth: thickness,
            angleRadians: angleRadians,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center + centerOffset;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - perpAngle;
    final anglePerpPlus = angleRadians;
    final anglePerpMinus = angleRadians - perpAngle * 2;

    final length = size.shortestSide * 0.5 * handSize;
    final pointWidth = 0.6;

    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final positionWithWidthPlus = position + Offset(math.cos(anglePerpPlus), math.sin(anglePerpPlus)) * pointWidth;
    final positionWithWidthMinus = position + Offset(math.cos(anglePerpMinus), math.sin(anglePerpMinus)) * pointWidth;

    final positionNeg = center - Offset(math.cos(angle), math.sin(angle)) * (length / 4);
    final positionNegWithWidthPlus = positionNeg + Offset(math.cos(anglePerpPlus), math.sin(anglePerpPlus)) * pointWidth;
    final positionNegWithWidthMinus = positionNeg + Offset(math.cos(anglePerpMinus), math.sin(anglePerpMinus)) * pointWidth;

    final positionPerpPlus = center + Offset(math.cos(anglePerpPlus), math.sin(anglePerpPlus)) * (lineWidth / 2);
    final positionPerpMinus = center + Offset(math.cos(anglePerpMinus), math.sin(anglePerpMinus)) * (lineWidth /2);

    final _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(position.dx, position.dy);
    path.lineTo(positionWithWidthPlus.dx, positionWithWidthPlus.dy);
    path.lineTo(positionPerpPlus.dx, positionPerpPlus.dy);
    path.lineTo(positionNegWithWidthPlus.dx, positionNegWithWidthPlus.dy);
    path.lineTo(positionNegWithWidthMinus.dx, positionNegWithWidthMinus.dy);
    path.lineTo(positionPerpMinus.dx, positionPerpMinus.dy);
    path.lineTo(positionWithWidthMinus.dx, positionWithWidthMinus.dy);
    path.close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
