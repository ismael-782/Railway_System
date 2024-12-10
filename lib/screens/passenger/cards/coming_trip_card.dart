import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/settings/coming_trips.dart";
import "package:railway_system/data/booking_card_data.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/screens/passenger/settings/trip_summary.dart";
import "package:railway_system/utils.dart";

class ComingTripCard extends StatelessWidget {
  final BookingCardData bookingCardData;
  final bool clickable;

  const ComingTripCard({super.key, required this.bookingCardData, this.clickable = true});

  @override
  Widget build(BuildContext context) {
    var dbModel = context.watch<DBModel>();

    return GestureDetector(
      onTap: clickable && bookingCardData.status != "Waitlisted"
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripSummaryPage(bookingCardData: bookingCardData),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/railway.png",
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Train #${bookingCardData.trainID}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookingCardData.startsAtName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(minutesToTime(bookingCardData.sTime))
                          ],
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_right_alt_sharp, size: 50),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              bookingCardData.endsAtName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(minutesToTime(bookingCardData.fTime))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Duration: "),
                        Text(minutesToDuration(bookingCardData.fTime - bookingCardData.sTime)),
                        const SizedBox(width: 15),
                        const Text("Coach: "),
                        Text(bookingCardData.coach),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Reservation #: "),
                        Text(bookingCardData.reservationNo.toString()),
                        const SizedBox(width: 15),
                        const Text("Date: "),
                        Text(bookingCardData.date),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
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
                        (bookingCardData.status == "Temp" && clickable && !bookingCardData.isDependent
                            ? Expanded(
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // Get all reservation numbers that depend on this reservation number
                                        // For this booking along with the dependents:
                                        // Delete from temp_booking
                                        // Insert into paid_booking with a PaymentID

                                        var depenendsQuery = await dbModel.conn.execute("SELECT * FROM booking WHERE DependsOn_ReservationNo = ${bookingCardData.reservationNo}");

                                        var reservationNumbers = [bookingCardData.reservationNo, ...depenendsQuery.rows.map((row) => row.colByName("ReservationNo")!)];

                                        for (var resNo in reservationNumbers) {
                                          await dbModel.conn.execute("DELETE FROM temp_booking WHERE ReservationNo = $resNo");
                                          await dbModel.conn.execute("INSERT INTO paid_booking (ReservationNo, PaymentID) VALUES ($resNo, 1)");
                                        }

                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ComingTripsPage()));
                                      },
                                      child: const Text(
                                        "Pay",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink())
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
