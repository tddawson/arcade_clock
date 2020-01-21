import 'dart:math';

import 'ball.dart';

class Paddle {
  Paddle({this.x, this.y, this.width, this.height, this.speed});

  double x;
  double y;
  double width;
  double height;
  double speed;

  void update(Ball ball) {
    // Move and check collision if close enough to "see" it.
    if ((x - ball.x).abs() < 200) {
      double diff = (y + (height / 2)) - (ball.y + (ball.size / 2));
      if (diff < 0) {
        y += min(speed, diff.abs());
      } else if (diff > 0) {
        y -= min(speed, diff);
      }

      checkBounce(ball);
    }
  }

  void checkBounce(ball) {
    if (y < ball.y + ball.size &&
        y + height > ball.y &&
        x < ball.x + ball.size &&
        x + width > ball.x) {
      ball.bounceHorizontally();
    }
  }
}
