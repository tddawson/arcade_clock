// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:analog_clock/paddle.dart';
import 'package:flutter/material.dart';
import 'ball.dart';
import 'paddle.dart';
import 'score.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class Arcade extends StatelessWidget {
  const Arcade(
      {@required this.ball,
      @required this.minutePaddle,
      @required this.hourPaddle,
      @required this.score,
      @required this.actualHours,
      @required this.actualMinutes,
      @required this.backgroundColor,
      @required this.primaryColor,
      @required this.accentColor,
      });

  final Ball ball;
  final Paddle minutePaddle;
  final Paddle hourPaddle;
  final Score score;
  final int actualHours;
  final int actualMinutes;
  final Color backgroundColor;
  final Color primaryColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _ArcadePainter(
              ball: ball,
              minutePaddle: minutePaddle,
              hourPaddle: hourPaddle,
              actualHours: actualHours,
              actualMinutes: actualMinutes,
              score: score,
              backgroundColor: backgroundColor,
              primaryColor: primaryColor,
              accentColor: accentColor),
        ),
      ),
    );
  }
}

class _ArcadePainter extends CustomPainter {
  _ArcadePainter({
    @required this.ball,
    @required this.minutePaddle,
    @required this.hourPaddle,
    @required this.score,
    @required this.actualHours,
    @required this.actualMinutes,
    @required this.backgroundColor,
    @required this.primaryColor,
    @required this.accentColor,
  });

  Ball ball;
  Paddle minutePaddle;
  Paddle hourPaddle;
  Score score;
  int actualHours;
  int actualMinutes;
  Color backgroundColor;
  Color primaryColor;
  Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint();
    backgroundPaint.color = backgroundColor;

    final primaryPaint = Paint();
    primaryPaint.color = primaryColor;

    final accentPaint = Paint();
    accentPaint.color = accentColor;

    // Clear screen
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Draw dashed line down the middle
    double dashY = 0;
    double dashSize = 5.0;
    int dashNum = 0;
    while (dashY < size.height) {
      canvas.drawRect(
          Rect.fromLTWH((size.width - dashSize) / 2, dashY, dashSize, dashSize),
          (dashNum == 2 || dashNum == 3) ? primaryPaint : accentPaint);
      dashY += dashSize * 2;
      dashNum++;
    }

    // Draw paddles
    hourPaddle.setScreenSize(size.width, size.height);
    minutePaddle.setScreenSize(size.width, size.height);
    double xOffset = 20;
    hourPaddle.x = xOffset;
    minutePaddle.x = size.width - (xOffset + minutePaddle.width);
    canvas.drawRect(
        Rect.fromLTWH(
            hourPaddle.x, hourPaddle.y, hourPaddle.width, hourPaddle.height),
        primaryPaint);
    canvas.drawRect(
        Rect.fromLTWH(minutePaddle.x, minutePaddle.y, minutePaddle.width,
            minutePaddle.height),
        primaryPaint);

    // Update and draw ball
    if (ball.scored(size.width)) {
      // Reset ball location
      ball.x = size.width / 2;
      ball.y = size.height / 2;

      // Update score to match time
      score.hourScore = actualHours;
      score.minuteScore = actualMinutes;
    }
    ball.checkBounce(size.height);
    canvas.drawRect(
        Rect.fromLTWH(ball.x, ball.y, ball.size, ball.size), primaryPaint);
  }

  @override
  bool shouldRepaint(_ArcadePainter oldDelegate) {
    return true;
  }
}
