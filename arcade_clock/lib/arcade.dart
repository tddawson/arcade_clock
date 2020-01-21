// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:analog_clock/paddle.dart';
import 'package:flutter/material.dart';
import 'ball.dart';
import 'paddle.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class Arcade extends StatelessWidget {
  const Arcade({
    @required this.ball,
    @required this.minutePaddle,
    @required this.hourPaddle,
  });

  final Ball ball;
  final Paddle minutePaddle;
  final Paddle hourPaddle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _ArcadePainter(
              ball: ball, minutePaddle: minutePaddle, hourPaddle: hourPaddle),
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
  });

  Ball ball;
  Paddle minutePaddle;
  Paddle hourPaddle;

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint();
    blackPaint.color = Colors.black;

    final whitePaint = Paint();
    whitePaint.color = Colors.white;

    final grayPaint = Paint();
    grayPaint.color = Colors.white30;

    // Clear screen
    canvas.drawRect(Offset.zero & size, blackPaint);

    // Draw dashed line down the middle
    double dashY = 0;
    double dashSize = 5.0;
    int dashNum = 0;
    while (dashY < size.height) {
      canvas.drawRect(
          Rect.fromLTWH((size.width - dashSize) / 2, dashY, dashSize, dashSize),
          (dashNum == 2 || dashNum == 3) ? whitePaint : grayPaint);
      dashY += dashSize * 2;
      dashNum++;
    }

    // Draw paddles
    double xOffset = 20;
    hourPaddle.x = xOffset;
    minutePaddle.x = size.width - (xOffset + minutePaddle.width);
    canvas.drawRect(
        Rect.fromLTWH(
            hourPaddle.x, hourPaddle.y, hourPaddle.width, hourPaddle.height),
        whitePaint);
    canvas.drawRect(
        Rect.fromLTWH(minutePaddle.x, minutePaddle.y, minutePaddle.width,
            minutePaddle.height),
        whitePaint);

    // Draw ball
    ball.checkBounces(size.width, size.height);
    canvas.drawRect(
        Rect.fromLTWH(ball.x, ball.y, ball.size, ball.size), whitePaint);
  }

  @override
  bool shouldRepaint(_ArcadePainter oldDelegate) {
    return true;
  }
}
