class BookingCardData {
  BookingCardData({
    required this.reservationNo,
    required this.trainID,
    required this.startsAtName,
    required this.endsAtName,
    required this.coach,
    required this.date,
    required this.status,
    required this.sTime,
    required this.fTime,
    this.seatNumber,
    this.listOrder,
    this.dependents,
  });

  String reservationNo;
  String trainID;
  String startsAtName;
  String endsAtName;
  String coach;
  String date;
  String status;
  String? seatNumber;
  String? listOrder;
  List<String>? dependents;
  int sTime;
  int fTime;
}
