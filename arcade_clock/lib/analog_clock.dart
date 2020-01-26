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
import 'score.dart';

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
  Paddle minutePaddle = Paddle(x: 0, y: 20, height: 50, width: 10, speed: 3, isHourHand: false);
  Paddle hourPaddle = Paddle(x: 0, y: 20, height: 50, width: 10, speed: 3, isHourHand: true);
  Score score;

  @override
  void initState() {
    super.initState();
    
    score = Score(hourScore: _now.hour, minuteScore: _now.minute);

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

      bool shouldScoreMinutes = false;
      bool shouldScoreHours = false;
      if (score.hourScore != int.parse(DateFormat('H').format(_now))) {
        shouldScoreHours = true;
      }
      else if (score.minuteScore != int.parse(DateFormat('m').format(_now))) {
        shouldScoreMinutes = true;
      }

      minutePaddle.update(ball, shouldScoreMinutes, shouldScoreHours);
      hourPaddle.update(ball, shouldScoreMinutes, shouldScoreHours);

      _timer = Timer(
        Duration(milliseconds: 1000 ~/ 60),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    final customTheme = Theme.of(context).brightness == Brightness.dark ?
      Theme.of(context).copyWith(backgroundColor: Colors.black, primaryColor: Colors.white, accentColor: Colors.white30) :
      Theme.of(context).copyWith(backgroundColor: Colors.white, primaryColor: Colors.black, accentColor: Colors.black38);


    final time = DateFormat.Hms().format(DateTime.now());
    final scoreStyle = TextStyle(color: customTheme.primaryColor, fontSize: 30);
    
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
              score: score,
              actualHours: int.parse(DateFormat('H').format(_now)),
              actualMinutes: int.parse(DateFormat('m').format(_now)),
              backgroundColor: customTheme.backgroundColor,
              primaryColor: customTheme.primaryColor,
              accentColor: customTheme.accentColor
            ),
            Positioned.fill(
                left: -80,
                top: 10,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(score.hourScore.toString(),
                      style: GoogleFonts.pressStart2P(textStyle: scoreStyle)),
                )),
            Positioned.fill(
                left: 80,
                top: 10,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(score.minuteScore.toString(),
                      style: GoogleFonts.pressStart2P(textStyle: scoreStyle)),
                )),
            // Example of a hand drawn with [CustomPainter].
          ],
        ),
      ),
    );
  }
}
