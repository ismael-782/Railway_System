class TrainCardData {
  final int trainID;
  final String nameEN;
  final String nameAR;
  final String source;
  final String destination;
  final String date;
  final int sTime;
  final int fTime;

  TrainCardData({
    required this.trainID,
    required this.nameEN,
    required this.nameAR,
    required this.source,
    required this.destination,
    required this.date,
    required this.sTime,
    required this.fTime,
  });

  int duration() {
    return fTime - sTime;
  }
}
