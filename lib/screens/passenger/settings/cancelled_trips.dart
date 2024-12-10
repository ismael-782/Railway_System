import "package:mysql_client/mysql_client.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/cards/cancelled_trip_cart.dart";
import "package:railway_system/data/booking_card_data.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

class CancelledTripsPage extends StatefulWidget {
  const CancelledTripsPage({super.key});

  @override
  State<CancelledTripsPage> createState() => _CancelledTripsPageState();
}

class _CancelledTripsPageState extends State<CancelledTripsPage> {
  List<BookingCardData> cardsData = [];
  bool gotData = false;

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var userModel = context.read<UserModel>();
    var dbModel = context.read<DBModel>();

    var cancelledQuery = await dbModel.conn.execute("SELECT * FROM booking b NATURAL JOIN cancelled_booking WHERE b.BelongsTo_ID = '${userModel.id()}'");

    List<BookingCardData> tmpCardsData = [];
    ResultSetRow searchResult;

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
    var userModel = context.watch<UserModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(210), // Adjust the height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0), // AppBar background color
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0), // Left bottom corner
              bottomRight: Radius.circular(30.0), // Right bottom corner
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color with opacity
                spreadRadius: 5, // Spread of the shadow
                blurRadius: 10, // Blur effect for shadow
                offset: const Offset(0, 4), // Offset for shadow position
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 200,
            leading: Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: Column(
              children: [
                const Icon(
                  color: Colors.blueGrey,
                  Icons.account_circle,
                  size: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome ${userModel.name()}! 👋",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Ensure text color is black or any other contrast color
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Passenger ID: ${userModel.id()}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            centerTitle: false, // Center title
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 8, 0, 8),
            child: Text(
              "Cancelled Trips",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: cardsData.map((BookingCardData bookingCardData) {
                    return Column(
                      children: [
                        CancelledTripCard(bookingCardData: bookingCardData),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
