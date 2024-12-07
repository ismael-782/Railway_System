class TrainCardData {
  final int trainID;
  final String nameEN;
  final String nameAR;
  final String source;
  final String destination;
  final String date;
  final int sTime;
  final int fTime;
  final int businessCapacity;
  final int economyCapacity;
  final int bookedBusiness;
  final int bookedEconomy;

  TrainCardData({
    required this.trainID,
    required this.nameEN,
    required this.nameAR,
    required this.source,
    required this.destination,
    required this.date,
    required this.sTime,
    required this.fTime,
    required this.businessCapacity,
    required this.economyCapacity,
    required this.bookedBusiness,
    required this.bookedEconomy,
  });

  int duration() {
    return fTime - sTime;
  }

  int remainingBusiness() {
    return businessCapacity - bookedBusiness;
  }

  int remainingEconomy() {
    return economyCapacity - bookedEconomy;
  }
}
