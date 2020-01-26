class Score {
  Score({this.hourScore, this.minuteScore});

  int hourScore;
  int minuteScore;

  String hourDisplay() {
    return hourScore.toString();
  }

  String minuteDisplay() {
    if (minuteScore < 10) {
      return "0" + minuteScore.toString();
    }
    return minuteScore.toString();
  }
}