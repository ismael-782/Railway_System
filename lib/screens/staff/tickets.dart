import "package:mysql_client/mysql_client.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";
import "package:railway_system/data/booking_card_data.dart";

import "package:railway_system/screens/staff/cards/staff_search_trip_card.dart";
import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/screens/staff/staff_trip_summary.dart";
import "package:railway_system/utils.dart";

class StaffTickets extends StatefulWidget {
  const StaffTickets({super.key});

  @override
  State<StaffTickets> createState() => _StaffTicketsState();
}

class _StaffTicketsState extends State<StaffTickets> {
  Map<String, List<String>> destinationsFromSource = {}; // Given a source, return the possible destinations
  List<String> stations = []; // All stations (possible sources)
  List<int> reservationNumbers = []; // All reservation numbers

  List<TrainCardData> cardsData = [];

  String source = "";
  String destination = "";

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  DateTime? selectedDate;

  int selectedReservationNo = 0;

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();
    var stationQuery = await dbModel.conn.execute("SELECT * FROM station");

    stations = stationQuery.rows.toList().map((row) => row.colByName("Name")!).toList();
    source = stations[0];

    var connectedToQuery = await dbModel.conn.execute("SELECT * FROM connected_to");

    for (var station in stations) {
      List<String> checked = [station];
      List<String> toCheck = [
        ...connectedToQuery.rows.toList().where((row) => row.colByName("Station1") == station).map((row) => row.colByName("Station2")!),
        ...connectedToQuery.rows.toList().where((row) => row.colByName("Station2") == station).map((row) => row.colByName("Station1")!),
      ];

      while (toCheck.isNotEmpty) {
        var current = toCheck.removeAt(0);

        if (!checked.contains(current)) {
          checked.add(current);
          toCheck.addAll(connectedToQuery.rows.toList().where((row) => row.colByName("Station1") == current).map((row) => row.colByName("Station2")!).toList());
          toCheck.addAll(connectedToQuery.rows.toList().where((row) => row.colByName("Station2") == current).map((row) => row.colByName("Station1")!).toList());
        }
      }

      destinationsFromSource[station] = checked.where((element) => element != station).toList();
    }

    destination = destinationsFromSource[source]![0];

    var reservationsQuery = await dbModel.conn.execute("SELECT * FROM booking");

    reservationNumbers = reservationsQuery.rows.toList().map((row) => int.parse(row.colByName("ReservationNo")!)).toList();
    selectedReservationNo = reservationNumbers[0];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbModel = context.read<DBModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reservation Lookup",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  "Reservation No",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                DropdownButton<int>(
                                  value: selectedReservationNo,
                                  items: reservationNumbers.map((resNo) {
                                    return DropdownMenuItem(
                                      value: resNo,
                                      child: Text(resNo.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedReservationNo = value!;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Get the reservation details and create a BookingCardData object
                                    var reservationQuery = await dbModel.conn.execute("SELECT * FROM booking WHERE ReservationNo = $selectedReservationNo");
                                    var reservation = reservationQuery.rows.toList().first;

                                    var times = (await dbModel.conn.execute("""
SELECT 
    pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
FROM
    passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
                        JOIN train t ON pt1.TrainID = t.ID
WHERE
    pt1.StationName = '${reservation.colByName("StartsAt_Name")!}' AND pt2.StationName = '${reservation.colByName("EndsAt_Name")!}' AND t.ID = ${reservation.colByName("On_ID")!} AND pt1.SequenceNo < pt2.SequenceNo ORDER BY pt1.TrainID , pt1.SequenceNo;
                          """)).rows.first;

                                    var isPaid = (await dbModel.conn.execute("SELECT * FROM paid_booking WHERE ReservationNo = $selectedReservationNo")).rows.isNotEmpty;
                                    var isWaitlisted = (await dbModel.conn.execute("SELECT * FROM waitlisted_booking WHERE ReservationNo = $selectedReservationNo")).rows.isNotEmpty;
                                    var isTemp = (await dbModel.conn.execute("SELECT * FROM temp_booking WHERE ReservationNo = $selectedReservationNo")).rows.isNotEmpty;
                                    var isCancelled = (await dbModel.conn.execute("SELECT * FROM cancelled_booking WHERE ReservationNo = $selectedReservationNo")).rows.isNotEmpty;

                                    var status = "";
                                    if (isCancelled) {
                                      status = "Cancelled";
                                    } else if (isPaid) {
                                      status = "Paid";
                                    } else if (isWaitlisted) {
                                      status = "Waitlisted";
                                    } else if (isTemp) {
                                      status = "Temp";
                                    }

                                    var bookingCardData = BookingCardData(
                                      reservationNo: selectedReservationNo.toString(),
                                      date: reservation.colByName("Date")!,
                                      coach: reservation.colByName("Coach")!,
                                      trainID: reservation.colByName("On_ID")!,
                                      startsAtName: reservation.colByName("StartsAt_Name")!,
                                      endsAtName: reservation.colByName("EndsAt_Name")!,
                                      status: status,
                                      isDependent: reservation.colByName("DependsOn_ReservationNo") != null,
                                      sTime: int.parse(times.colByName("S_Time")!),
                                      fTime: int.parse(times.colByName("F_Time")!),
                                    );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StaffTripSummaryPage(bookingCardData: bookingCardData),
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "GET TICKET",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.arrow_forward_ios, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Reserve a Train",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "From",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(width: 139),
                          Text(
                            "To",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: source,
                              hint: const Text("Departure Station"),
                              isExpanded: true,
                              items: stations.map((station) {
                                return DropdownMenuItem(
                                  value: station,
                                  child: Text(station),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  source = value!;
                                  destination = destinationsFromSource[source]?.first ?? "";
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButton<String>(
                              value: destination,
                              hint: const Text("Arrival Station"),
                              isExpanded: true,
                              items: (destinationsFromSource[source] ?? []).map((station) {
                                return DropdownMenuItem(
                                  value: station,
                                  child: Text(station),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  destination = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDate == null ? "Select Date" : "${selectedDate!.toLocal()}".split(" ")[0],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (selectedDate == null) {
                              showSnackBar(context, "Please select a date.");
                              return;
                            }

                            if (DateTime.now().isAfter(selectedDate!)) {
                              showSnackBar(context, "Please select a future date.");
                              return;
                            }

                            String selectedYear = selectedDate!.year.toString();
                            String selectedMonth = selectedDate!.month.toString().padLeft(2, "0"); // Ensure 2 digits
                            String selectedDay = selectedDate!.day.toString().padLeft(2, "0"); // Ensure 2 digits

                            var searchResult = (await dbModel.conn.execute("""
            SELECT 
        pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
            FROM
        passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
            JOIN train t ON pt1.TrainID = t.ID
            WHERE
        pt1.StationName = '$source' AND pt2.StationName = '$destination' AND pt1.SequenceNo < pt2.SequenceNo 
            ORDER BY pt1.TrainID, pt1.SequenceNo;
      """)).rows.toList();

                            var bookings = (await dbModel.conn.execute("""
            SELECT *
            FROM booking NATURAL JOIN listed_booking
            WHERE
            Date = '$selectedYear-$selectedMonth-$selectedDay'
      """)).rows.toList();

                            cardsData = searchResult.map((ResultSetRow row) {
                              return TrainCardData(
                                trainID: int.parse(row.colByName("TrainID")!),
                                nameEN: row.colByName("NameEN")!,
                                nameAR: row.colByName("NameAR")!,
                                source: source,
                                destination: destination,
                                date: "$selectedYear-$selectedMonth-$selectedDay",
                                sTime: int.parse(row.colByName("S_Time")!),
                                fTime: int.parse(row.colByName("F_Time")!),
                                businessCapacity: int.parse(row.colByName("BusinessCapacity")!),
                                economyCapacity: int.parse(row.colByName("EconomyCapacity")!),
                                bookedBusiness: bookings.where((booking) => booking.colByName("On_ID") == row.colByName("TrainID") && booking.colByName("Coach") == "Business").length,
                                bookedEconomy: bookings.where((booking) => booking.colByName("On_ID") == row.colByName("TrainID") && booking.colByName("Coach") == "Economy").length,
                              );
                            }).toList();

                            setState(() {});
                          },
                          child: const Text(
                            "SEARCH",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Available Trains",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: (cardsData.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "No trains available", // Placeholder text
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(5, 0),
                            ),
                          ],
                        ),
                        child: ListView(
                          children: cardsData.map((TrainCardData trainCardData) {
                            return Column(
                              children: [
                                StaffSearchTripCard(
                                  trainCardData: trainCardData,
                                  clickable: true,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
