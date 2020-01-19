// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:analog_clock/drawn_clock_face.dart';
import 'package:analog_clock/weather_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'drawn_hand.dart';
import 'clock_pin.dart';
import 'constants.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;

    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: blue,
            highlightColor: Color(0xFF8AB4F8),
            //accentColor: Color.fromARGB(255, 25, 25, 25),
            accentColor: darkerGrey,
            backgroundColor: Color.fromARGB(60, 175, 175, 175),
            canvasColor: Color.fromARGB(155, 225, 225, 225),
            focusColor: Color.fromARGB(205, 225, 225, 225),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color.fromARGB(255, 225, 225, 225),
            highlightColor: Color(0xFF4285F4),
            //accentColor: Color.fromARGB(255, 225, 225, 225),
            accentColor: midGrey,
            backgroundColor: Color.fromARGB(60, 75, 75, 75),
            canvasColor: Color.fromARGB(155, 75, 75, 75),
            focusColor: Color.fromARGB(205, 225, 225, 225),
    );

    final invertedTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
          )
        : Theme.of(context).copyWith(
          // Hour hand.
          primaryColor: Color(0xFF4285F4),
          // Minute hand.
          highlightColor: Color(0xFF8AB4F8),
          // Second hand.
          accentColor: Color(0xFF669DF6),
          backgroundColor: Color(0xFFF2F2F2),
    );

    final time = DateFormat.Hms().format(DateTime.now());

    final topInfo = DefaultTextStyle(
      style: TextStyle(color: midGrey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                style: GoogleFonts.robotoMono(color: invertedTheme.backgroundColor, fontSize: 20),
                children: <TextSpan>[
                  TextSpan(text: time, style: GoogleFonts.robotoMono(fontSize: 40)),
                  TextSpan(text: DateFormat('a').format(DateTime.now())),
                ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.robotoMono(color: getAccompanyingColor(_condition), fontSize: 20),
              children: <TextSpan>[
                TextSpan(text: DateFormat('EEEE  ').format(DateTime.now()), style: GoogleFonts.robotoMono(fontWeight: FontWeight.w900)),
                TextSpan(text: DateFormat('d MMM  yyyy').format(DateTime.now())),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
            child: SizedBox(
            width: 250,
            height: 100,
              child: Text(_location, style: GoogleFonts.robotoMono(fontSize: 15, fontWeight: FontWeight.w300, color: customTheme.accentColor), overflow: TextOverflow.visible),
            ),
          )
        ],
      ),
    );

    final bottomInfo = DefaultTextStyle(
      style: TextStyle(color: midGrey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeatherRow(weatherCondition: _condition, iconSize: 20, stringToDisplay: _temperature),
          Text(_temperatureRange, style: GoogleFonts.robotoMono(fontWeight: FontWeight.w300, color: customTheme.accentColor, fontSize: 12)),
        ],
      ),
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
//            Center(
//                child: Image.asset('assets/drawing.png', height: 524.0, width: 845, fit: BoxFit.cover)
//            ),
            Positioned(
              left: 9,
              top: 9 ,
              child: Container(
                decoration: BoxDecoration(
                  color: customTheme.backgroundColor,
                    shape: BoxShape.circle
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: 488,
                    height: 488,
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                        child: Text("     ")
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 9,
              top: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: customTheme.canvasColor,
                ),
                child: ClipRect(
                  child: SizedBox(
                    width: 300,
                    height: 240,
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                        child: Text("     ")
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                DrawnClockFace(
                    color: yellow,
                    majorTickThickness: 5,
                    thickness: 2
                ),
                // Example of a hand drawn with [CustomPainter].
                DrawnHand(
                    color: blue,
                    thickness: 32,
                    size: 0.5,
                    angleRadians: _now.hour * radiansPerHour +
                        (_now.minute / 60) * radiansPerHour
                ),
                DrawnHand(
                  color: green,
                  thickness: 16,
                  size: 0.75,
                  angleRadians: _now.minute * radiansPerTick,
                ),
                DrawnHand(
                  color: red,
                  thickness: 8,
                  size: 0.9,
                  angleRadians: _now.second * radiansPerTick,
                ),
                ClockPin(
                  color: (Color.fromARGB(255, 255, 255, 255)),
                  thickness: 1,
                  fillColor: (Color.fromARGB(255, 0, 0, 0)),
                  shortestSide: 2,
                ),
              ]
            ),
            Positioned(
              width: 300,
              right: 0,
              top: 150,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: topInfo,
              ),
            ),
            Positioned(
              width: 300,
              right: 0,
              bottom: 125,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: bottomInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color getAccompanyingColor(String weatherCondition) {
    switch(weatherCondition){
      case 'cloudy' : {
        return yellow;
      }
      case 'foggy' : {
        return yellow;
      }
      case 'rainy' : {
        return blue;
      }
      case 'snowy' : {
        return green;
      }
      case 'sunny' : {
        return red;
      }
      case 'thunderstorm' : {
        return red;
      }
      case 'windy' : {
        return blue;
      }
    }
    return green;
  }
}
