import "package:flutter/material.dart";

import "package:railway_system/data/booking_card_data.dart";
import "package:railway_system/screens/passenger/book.dart";

class TripSummaryPage extends StatelessWidget {
  final BookingCardData bookingCardData;

  const TripSummaryPage({super.key, required this.bookingCardData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.confirmation_number_sharp),
              SizedBox(width: 10),
              Text(
                "Booking Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Trip:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // put details basically train id, date, source, and destination
          Text(
            "Train ID: ${bookingCardData.trainID}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Date: ${bookingCardData.date}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Source: ${bookingCardData.startsAtName}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Destination: ${bookingCardData.endsAtName}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Text(
            "Passengers:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...List.generate(dependents.length + 1, (index) {
            String passenger = index == 0 ? userModel.id() : dependents[index - 1];
            String seatType = seats[index]! <= widget.trainCardData.businessCapacity ? "Business" : "Economy";
            int seatCost = seats[index]! <= widget.trainCardData.businessCapacity ? 300 : 150;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      passenger,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      seatType,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Seat ${seats[index]}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${seatCost.toString()} SAR",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          const Text(
            "Total Cost:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Builder(
            builder: (context) {
              double totalCost = 0;

              for (int i = 0; i < dependents.length + 1; i++) {
                totalCost += seats[i]! <= widget.trainCardData.businessCapacity ? 300 : 150;
              }

              bool familyDiscount = false;
              String? milesDiscount;

              if (dependents.isNotEmpty) {
                familyDiscount = true;
                totalCost *= 0.75;
              }

              if (milesTravelled >= 100000) {
                milesDiscount = "25%";
                totalCost *= 0.75;
              } else if (milesTravelled >= 50000) {
                milesDiscount = "10%";
                totalCost *= 0.9;
              } else if (milesTravelled >= 10000) {
                milesDiscount = "5%";
                totalCost *= 0.95;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (familyDiscount)
                    const Text(
                      "Family Discount: 25%",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  if (milesDiscount != null)
                    Text(
                      "Miles Discount: $milesDiscount",
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  Text(
                    "${totalCost.toString()} SAR",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ],
              );
            },
          ),
          // back button and confirm button
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                  onPressed: () {
                    setState(() {
                      step = 1;
                    });
                  },
                  child: const Text("BACK", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                  onPressed: () async {
                    // INSERT INTO booking (ReservationNo, Date, Coach, On_ID, StartsAt_Name, EndsAt_Name, DependsOn_ReservationNo, BelongsTo_ID)
                    // use this to insert the booking into the system and then
                    // INSERT INTO listed_booking (ReservationNo, SeatNumber)

                    // for each passenger, insert the booking and then insert the listed_booking
                    // the reservationno is auto_increment
                    // await dbModel.conn.execute("""INSERT INTO booking (Date, Coach, On_ID, StartsAt_Name, EndsAt_Name, DependsOn_ReservationNo, BelongsTo_ID) VALUES (
                    // '${widget.date}', '${seats[currentPassenger]! < 9 ? "Business" : "Economy"}', '${widget.trainID}', '${widget.source}', '${widget.destination}', NULL, '${currentPassenger == 0 ? userModel.id() : dependents[currentPassenger - 1]}'));
                    // )""");

                    // Loop through a list that contains passenger then ...dependents
                    // For each person, insert their booking into the database
                    // Retrieve its booking reservation no
                    // Insert that with their seat into the listed_booking table

                    for (int i = 0; i < dependents.length + 1; i++) {
                      if (i > 0) {
                        // if the dependent does not exist as a passenger in the system
                        // then insert them into the user table with password=NULL
                        // and passenger table with milestravelled=0
                        var result = await dbModel.conn.execute("SELECT * FROM passenger WHERE ID = '${dependents[i - 1]}'");

                        if (result.rows.isEmpty) {
                          await dbModel.conn.execute("INSERT INTO user (ID, Password) VALUES ('${dependents[i - 1]}', NULL)");
                          await dbModel.conn.execute("INSERT INTO passenger (ID, MilesTravelled) VALUES ('${dependents[i - 1]}', 0)");
                        }
                      }
                      await dbModel.conn.execute("""
    INSERT INTO booking (Date, Coach, On_ID, StartsAt_Name, EndsAt_Name, DependsOn_ReservationNo, BelongsTo_ID)
    VALUES ('${widget.date}', '${seats[i]! < 9 ? "Business" : "Economy"}', '${widget.trainID}', '${widget.source}', '${widget.destination}', NULL, '${i == 0 ? userModel.id() : dependents[i - 1]}');
    """);

                      var result = await dbModel.conn.execute("SELECT MAX(ReservationNo) FROM booking");
                      int reservationNo = int.parse(result.rows.first.colAt(0)!);

                      await dbModel.conn.execute("""
    INSERT INTO listed_booking (ReservationNo, SeatNumber)
    VALUES ($reservationNo, ${seats[i]});
    """);
                    }

                    showSnackBar(context, "Booking confirmed.");
                    Navigator.pop(context);
                  },
                  child: const Text("CONFIRM", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
