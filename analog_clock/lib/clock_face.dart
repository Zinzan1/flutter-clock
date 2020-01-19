// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A base class for an analog clock hand-drawing widget.
///
/// This only draws one hand of the analog clock. Put it in a [Stack] to have
/// more than one hand.
abstract class ClockFace extends StatelessWidget {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const ClockFace({
    @required this.color,
    @required this.tickThickness,
    @required this.majorTickThickness,
  })  : assert(color != null),
        assert(majorTickThickness != null),
        assert(tickThickness != null);

  /// Hand color.
  final Color color;

  /// Radius of the clock, as a percentage of the smaller side of the clock's parent
  /// container.
  final double tickThickness;

  final double majorTickThickness;
}
