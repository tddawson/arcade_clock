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

  bool scored(width) {
    return x >= width - size || x <= 0;
  }

  void checkBounce(height) {
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
