// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:analog_clock/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class WeatherRow extends StatelessWidget {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const WeatherRow({
    @required this.stringToDisplay,
    @required this.weatherCondition,
    @required this.iconSize,
  })  : assert(stringToDisplay != null),
        assert(weatherCondition != null),
        assert(iconSize != null);

  /// How thick the hand should be drawn, in logical pixels.
  final String stringToDisplay;
  final String weatherCondition;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: SizedBox.fromSize(
              child: SvgPicture.asset(mapConditionToSVG(weatherCondition), color: mapConditionToColor(weatherCondition),),
              size: Size(24, 24),
            ),
          ),
          RichText(
              text: TextSpan(
                style: GoogleFonts.robotoMono(fontSize: iconSize, color: mapConditionToColor(weatherCondition)),
                  text: stringToDisplay
              ),
          ),
        ],
      ),
    );
  }

  String mapConditionToSVG(String weatherCondition) {
    switch(weatherCondition){
      case 'cloudy' : {
        return 'assets/cloudy.svg';
      }
      case 'foggy' : {
        return 'assets/foggy.svg';
      }
      case 'rainy' : {
        return 'assets/rainy.svg';
      }
      case 'snowy' : {
        return 'assets/snowy.svg';
      }
      case 'sunny' : {
        return 'assets/sunny.svg';
      }
      case 'thunderstorm' : {
        return 'assets/thunder.svg';
      }
      case 'windy' : {
        return 'assets/windy.svg';
      }
    }
    return "assets/sunny.svg";
  }

  Color mapConditionToColor(String weatherCondition) {
    switch(weatherCondition){
      case 'cloudy' : {
        return midGrey;
      }
      case 'foggy' : {
        return midGrey;
      }
      case 'rainy' : {
        return green;
      }
      case 'snowy' : {
        return blue;
      }
      case 'sunny' : {
        return yellow;
      }
      case 'thunderstorm' : {
        return yellow;
      }
      case 'windy' : {
        return green;
      }
    }
    return yellow;
  }
}

