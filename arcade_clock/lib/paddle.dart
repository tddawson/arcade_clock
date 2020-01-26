import 'dart:math';

import 'ball.dart';

class Paddle {
  Paddle({this.x, this.y, this.width, this.height, this.speed, this.isHourHand});

  double x;
  double y;
  double width;
  double height;
  double screenHeight;
  double screenWidth;
  double speed;
  bool isHourHand;

  void setScreenSize(double w, double h) {
    screenWidth = w;
    screenHeight = h;
  }

  void update(Ball ball, bool shouldScoreMinutes, bool shouldScoreHours) {
    if (ballMovingTowards(ball)) {
      if (shouldLetScore(shouldScoreMinutes, shouldScoreHours)) {
        letScore(ball);
      } else {
        followBall(ball);
      }
    } else {
      returnToCenter();
    }
    clampY();

    checkBounce(ball);
  }

  void clampY() {
    if (screenHeight == null)
      return;
    y = min(max(y, 0), screenHeight - height);
  }

  void followBall(Ball ball) {
    goTowardsY(ball.y + (ball.size / 2));
  }

  void letScore(Ball ball) {
    if (screenHeight == null)
      return;
    if (ball.yDir > 0) {
      goTowardsY(0);
    } else {
      goTowardsY(screenHeight);
    }
  }

  void returnToCenter() {
    if (screenHeight == null)
      return;
    goTowardsY(screenHeight / 2);
  }

  void goTowardsY(double targetY) {
    double diff = (y + (height / 2)) - targetY;
    if (diff < 0) {
      y += min(speed, diff.abs());
    } else if (diff > 0) {
      y -= min(speed, diff);
    }
  }
  
  bool shouldLetScore(bool shouldScoreMinutes, bool shouldScoreHours) {
    return shouldScoreHours && isHourHand ||
      shouldScoreMinutes && !isHourHand;
  }

  bool ballMovingTowards(Ball ball) {
    return this.isHourHand && ball.xDir < 0 ||
      !this.isHourHand && ball.xDir > 0;
  }

  void checkBounce(Ball ball) {
    if (y < ball.y + ball.size &&
        y + height > ball.y &&
        x < ball.x + ball.size &&
        x + width > ball.x) {
      ball.bounceHorizontally();
    }
  }
}
