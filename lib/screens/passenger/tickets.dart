import "package:mysql_client/mysql_client.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/data/booking_card_data.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class PassengerTickets extends StatefulWidget {
  const PassengerTickets({super.key});

  @override
  State<PassengerTickets> createState() => _PassengerTicketsState();
}

class _PassengerTicketsState extends State<PassengerTickets> {
  List<BookingCardData> cardsData = [];
  bool gotData = false;

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();

    var tempQuery = await dbModel.conn.execute("SELECT * FROM booking b NATURAL JOIN temp_booking NATURAL JOIN listed_booking WHERE b.BelongsTo_ID = ${context.read<UserModel>().id()}");
    var paidQuery = await dbModel.conn.execute("SELECT * FROM booking b NATURAL JOIN paid_booking NATURAL JOIN listed_booking WHERE b.BelongsTo_ID = ${context.read<UserModel>().id()}");
    var waitlistedQuery = await dbModel.conn.execute("SELECT * FROM booking b NATURAL JOIN waitlisted_booking WHERE b.BelongsTo_ID = ${context.read<UserModel>().id()}");
    var cancelledQuery = await dbModel.conn.execute("SELECT * FROM booking b NATURAL JOIN cancelled_booking WHERE b.BelongsTo_ID = ${context.read<UserModel>().id()}");

    List<BookingCardData> tmpCardsData = [];
    ResultSetRow searchResult;

    for (var row in tempQuery.rows) {
      // Get the start and end times

      searchResult = (await dbModel.conn.execute("""
SELECT 
    pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
FROM
    passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
                        JOIN train t ON pt1.TrainID = t.ID
WHERE
    pt1.StationName = '${row.colByName("StartsAt_Name")!}' AND pt2.StationName = '${row.colByName("EndsAt_Name")!}' AND t.ID = ${row.colByName("On_ID")!} AND pt1.SequenceNo < pt2.SequenceNo ORDER BY pt1.TrainID , pt1.SequenceNo;
                          """)).rows.first;

      tmpCardsData.add(BookingCardData(
        reservationNo: row.colByName("ReservationNo")!,
        date: row.colByName("Date")!,
        coach: row.colByName("Coach")!,
        trainID: row.colByName("On_ID")!,
        startsAtName: row.colByName("StartsAt_Name")!,
        endsAtName: row.colByName("EndsAt_Name")!,
        seatNumber: row.colByName("SeatNumber")!,
        status: "Temp",
        sTime: int.parse(searchResult.colByName("S_Time")!),
        fTime: int.parse(searchResult.colByName("F_Time")!),
      ));
    }

    for (var row in paidQuery.rows) {
      searchResult = (await dbModel.conn.execute("""
SELECT 
    pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
FROM
    passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
                        JOIN train t ON pt1.TrainID = t.ID
WHERE
    pt1.StationName = '${row.colByName("StartsAt_Name")!}' AND pt2.StationName = '${row.colByName("EndsAt_Name")!}' AND t.ID = ${row.colByName("On_ID")!} AND pt1.SequenceNo < pt2.SequenceNo ORDER BY pt1.TrainID , pt1.SequenceNo;
                          """)).rows.first;

      tmpCardsData.add(BookingCardData(
        reservationNo: row.colByName("ReservationNo")!,
        date: row.colByName("Date")!,
        coach: row.colByName("Coach")!,
        trainID: row.colByName("On_ID")!,
        startsAtName: row.colByName("StartsAt_Name")!,
        endsAtName: row.colByName("EndsAt_Name")!,
        seatNumber: row.colByName("SeatNumber")!,
        status: "Paid",
        sTime: int.parse(searchResult.colByName("S_Time")!),
        fTime: int.parse(searchResult.colByName("F_Time")!),
      ));
    }

    for (var row in waitlistedQuery.rows) {
      searchResult = (await dbModel.conn.execute("""
SELECT 
    pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
FROM
    passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
                        JOIN train t ON pt1.TrainID = t.ID
WHERE
    pt1.StationName = '${row.colByName("StartsAt_Name")!}' AND pt2.StationName = '${row.colByName("EndsAt_Name")!}' AND t.ID = ${row.colByName("On_ID")!} AND pt1.SequenceNo < pt2.SequenceNo ORDER BY pt1.TrainID , pt1.SequenceNo;
                          """)).rows.first;

      tmpCardsData.add(BookingCardData(
        reservationNo: row.colByName("ReservationNo")!,
        date: row.colByName("Date")!,
        coach: row.colByName("Coach")!,
        trainID: row.colByName("On_ID")!,
        startsAtName: row.colByName("StartsAt_Name")!,
        endsAtName: row.colByName("EndsAt_Name")!,
        listOrder: row.colByName("ListOrder")!,
        status: "Waitlisted",
        sTime: int.parse(searchResult.colByName("S_Time")!),
        fTime: int.parse(searchResult.colByName("F_Time")!),
      ));
    }

    for (var row in cancelledQuery.rows) {
      searchResult = (await dbModel.conn.execute("""
SELECT 
    pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
FROM
    passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
                        JOIN train t ON pt1.TrainID = t.ID
WHERE
    pt1.StationName = '${row.colByName("StartsAt_Name")!}' AND pt2.StationName = '${row.colByName("EndsAt_Name")!}' AND t.ID = ${row.colByName("On_ID")!} AND pt1.SequenceNo < pt2.SequenceNo ORDER BY pt1.TrainID , pt1.SequenceNo;
                          """)).rows.first;

      tmpCardsData.add(BookingCardData(
        reservationNo: row.colByName("ReservationNo")!,
        date: row.colByName("Date")!,
        coach: row.colByName("Coach")!,
        trainID: row.colByName("On_ID")!,
        startsAtName: row.colByName("StartsAt_Name")!,
        endsAtName: row.colByName("EndsAt_Name")!,
        status: "Cancelled",
        sTime: int.parse(searchResult.colByName("S_Time")!),
        fTime: int.parse(searchResult.colByName("F_Time")!),
      ));
    }

    setState(() {
      cardsData = tmpCardsData;
      gotData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ((gotData == false)
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.blue[300],
          ))
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cardsData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: BookingCard(bookingCardData: cardsData[index]),
                    );
                  },
                ),
              )
            ],
          ));
  }
}

class BookingCard extends StatelessWidget {
  final BookingCardData bookingCardData;

  const BookingCard({super.key, required this.bookingCardData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Column(
            children: [
              const Icon(Icons.train, size: 50),
              Text("Train #${bookingCardData.trainID}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(bookingCardData.startsAtName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  const Text(" - "),
                  const Icon(Icons.arrow_forward),
                  const Text(" - "),
                  const SizedBox(width: 10),
                  Text(bookingCardData.endsAtName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    minutesToTime(bookingCardData.sTime),
                    textAlign: TextAlign.left,
                  ),
                  const Text("- - - - - - - - - - - - - - ", textAlign: TextAlign.center),
                  Text(minutesToTime(bookingCardData.fTime), textAlign: TextAlign.right),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(bookingCardData.date),
                  const SizedBox(width: 10),
                  const Text("•"),
                  const SizedBox(width: 10),
                  Text(bookingCardData.coach),
                ],
              ),
              const SizedBox(height: 2),
              Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    color: bookingCardData.status == "Temp"
                        ? Colors.blue[100]
                        : bookingCardData.status == "Paid"
                            ? Colors.green[100]
                            : bookingCardData.status == "Waitlisted"
                                ? Colors.orange[100]
                                : Colors.red[100],
                    border: Border.all(
                        color: bookingCardData.status == "Temp"
                            ? Colors.blue
                            : bookingCardData.status == "Paid"
                                ? Colors.green
                                : bookingCardData.status == "Waitlisted"
                                    ? Colors.orange
                                    : Colors.red),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(bookingCardData.status.toUpperCase(), textAlign: TextAlign.center)),
            ],
          ),
        ],
      ),
    );
  }
}
