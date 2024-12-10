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
    this.isDependent = false,
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
  int sTime;
  int fTime;
  bool isDependent;
}
