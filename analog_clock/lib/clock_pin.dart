// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:analog_clock/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class ClockPin extends StatelessWidget {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const ClockPin({
    @required this.fillColor,
    @required this.color,
    @required this.thickness,
    @required this.shortestSide,
  })  : assert(fillColor != null),
        assert(color != null),
        assert(thickness != null),
        assert(shortestSide != null);

  /// How thick the hand should be drawn, in logical pixels.
  final Color fillColor;
  final Color color;
  final double thickness;
  final double shortestSide;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            pinSize: shortestSide,
            outlineWidth: thickness,
            color: color,
            fillColor: fillColor,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.fillColor,
    @required this.pinSize,
    @required this.outlineWidth,
    @required this.color,
  })  : assert(fillColor != null),
        assert(pinSize != null),
        assert(outlineWidth != null),
        assert(color != null),
        assert(pinSize >= 0.0);

  double pinSize;
  double outlineWidth;
  Color color;
  Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center + centerOffset;
    // We want to start at the top, not at the x-axis, so add pi/2.

    final _paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final _outlinePaint = Paint()
      ..color = color
      ..strokeWidth = outlineWidth;

    canvas.drawCircle(center, pinSize, _paint);
    canvas.drawCircle(center, pinSize, _outlinePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.pinSize != pinSize ||
        oldDelegate.outlineWidth != outlineWidth ||
        oldDelegate.color != color;
  }
}
