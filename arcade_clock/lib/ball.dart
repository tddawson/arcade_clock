class Ball {
  Ball({this.x, this.y, this.xDir, this.yDir, this.size});

  double x;
  double y;
  double xDir;
  double yDir;
  double size;

  void update() {
    this.x += this.xDir;
    this.y += this.yDir;
  }

  void checkBounces(width, height) {
    if (x >= width - size) {
      x = width - size - 1;
      bounceHorizontally();
    } else if (x <= 0) {
      x = 1;
      bounceHorizontally();
    }

    if (y >= height - size) {
      y = height - size - 1;
      bounceVertically();
    }
    if (y <= 0) {
      y = 1;
      bounceVertically();
    }
  }

  void bounceVertically() {
    this.yDir *= -1;
  }

  void bounceHorizontally() {
    this.xDir *= -1;
  }
}
