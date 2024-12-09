import "package:flutter/material.dart";

import "package:railway_system/data/booking_card_data.dart";
import "package:railway_system/utils.dart";

class CancelledTripCard extends StatelessWidget {
  final BookingCardData bookingCardData;

  const CancelledTripCard({super.key, required this.bookingCardData});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
