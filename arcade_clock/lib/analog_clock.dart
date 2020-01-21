// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'arcade.dart';
import 'ball.dart';
import 'paddle.dart';

class ArcadeClock extends StatefulWidget {
  const ArcadeClock(this.model);

  final ClockModel model;

  @override
  _ArcadeClockState createState() => _ArcadeClockState();
}

class _ArcadeClockState extends State<ArcadeClock> {
  var _now = DateTime.now();
  Timer _timer;

  Ball ball = Ball(x: 40.0, y: 40.0, xDir: 2, yDir: 2, size: 10);
  Paddle minutePaddle = Paddle(x: 0, y: 20, height: 50, width: 10, speed: 15);
  Paddle hourPaddle = Paddle(x: 0, y: 20, height: 50, width: 10, speed: 15);

  @override
  void initState() {
    super.initState();
    // Set the initial values.
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      ball.update();
      minutePaddle.update(ball);
      hourPaddle.update(ball);

      _timer = Timer(
        Duration(milliseconds: 1000 ~/ 60),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());
    final scoreStyle = TextStyle(color: Colors.white, fontSize: 30);
    final hour = DateFormat('HH').format(_now);
    final minute = DateFormat('mm').format(_now);

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Arcade clock with time $time',
        value: time,
      ),
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [
            Arcade(
              ball: ball,
              hourPaddle: hourPaddle,
              minutePaddle: minutePaddle,
            ),
            Positioned.fill(
                left: -80,
                top: 10,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(hour,
                      style: GoogleFonts.pressStart2P(textStyle: scoreStyle)),
                )),
            Positioned.fill(
                left: 80,
                top: 10,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(minute,
                      style: GoogleFonts.pressStart2P(textStyle: scoreStyle)),
                )),
            // Example of a hand drawn with [CustomPainter].
          ],
        ),
      ),
    );
  }
}
