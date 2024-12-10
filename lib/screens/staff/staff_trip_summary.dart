import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/cards/coming_trip_card.dart";
import "package:railway_system/data/booking_card_data.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class StaffTripSummaryPage extends StatefulWidget {
  final BookingCardData bookingCardData;

  const StaffTripSummaryPage({super.key, required this.bookingCardData});

  @override
  State<StaffTripSummaryPage> createState() => _StaffTripSummaryPageState();
}

class _StaffTripSummaryPageState extends State<StaffTripSummaryPage> {
  List<String> passengers = [];
  Map<String, int> seats = {};
  int businessCapacity = 0;
  int economyCapacity = 0;

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();

    // Read the dependents of this booking based on the reservation number from BookingCardData
    // For each dependent and the user, read their seat number from listed_booking table SeatNumber

    var allPassengers = await dbModel.conn.execute("SELECT * FROM booking WHERE DependsOn_ReservationNo = ${widget.bookingCardData.reservationNo} OR ReservationNo = ${widget.bookingCardData.reservationNo}");

    // loop through allPassengers and add them to dependents and seats
    for (var passenger in allPassengers.rows) {
      String passengerID = passenger.colByName("BelongsTo_ID")!;
      passengers.add(passengerID);

      // If the booking is a listed booking, get the seat number

      var seatNumberQuery = await dbModel.conn.execute("SELECT * FROM listed_booking WHERE ReservationNo = ${passenger.colByName("ReservationNo")}");

      if (seatNumberQuery.rows.isNotEmpty) {
        int seatNumber = int.parse(seatNumberQuery.rows.first.colByName("SeatNumber")!);
        seats[passengerID] = seatNumber;
      }
    }

    // Get the business and economy capacity of the train
    var train = await dbModel.conn.execute("SELECT * FROM train WHERE ID = ${widget.bookingCardData.trainID}");
    businessCapacity = int.parse(train.rows.first.colByName("BusinessCapacity")!);
    economyCapacity = int.parse(train.rows.first.colByName("EconomyCapacity")!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbModel = context.watch<DBModel>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200), // Custom height for the AppBar
        child: Material(
          elevation: 8, // Shadow effect
          shadowColor: Colors.black.withOpacity(0.8), // Shadow color
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromARGB(15, 155, 155, 155),
              toolbarHeight: 100, // Set the AppBar height
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 20.0), // Adjust padding if needed
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ComingTripCard(
                    bookingCardData: widget.bookingCardData, // Include your TrainCard widget
                    clickable: false,
                  ),
                ),
              ),
              centerTitle: true, // Align the TrainCard widget in the center
            ),
          ),
        ),
      ),
      body: (passengers.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 0, 0)))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.confirmation_number_sharp),
                      SizedBox(width: 15),
                      Text(
                        //widget.bookingCardData.trainID
                        "Booking Summary",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trip Details Section
                          const Text(
                            "Trip Details",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date: ${widget.bookingCardData.date}", style: const TextStyle(fontSize: 16)),
                                Text("Source: ${widget.bookingCardData.startsAtName}", style: const TextStyle(fontSize: 16)),
                                Text("Destination: ${widget.bookingCardData.endsAtName}", style: const TextStyle(fontSize: 16)),
                                Text("Train Number: ${widget.bookingCardData.trainID}", style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Passengers Section
                          const Text(
                            "Passengers",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // Fixed Height and Scrollable Content
                          Container(
                            height: 100, // Fixed height to prevent container growth
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // Table Header
                                  const Row(
                                    children: [
                                      SizedBox(width: 120, child: Text("Passenger", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      SizedBox(width: 60, child: Text("Class", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      SizedBox(width: 60, child: Text("Seat", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      SizedBox(width: 60, child: Text("Cost", textAlign: TextAlign.right, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                  const Divider(),

                                  // Passenger Rows
                                  ...List.generate(passengers.length, (index) {
                                    String passenger = passengers[index];
                                    String seatType = widget.bookingCardData.status != "Waitlisted" && seats.containsKey(passenger) ? (seats[passenger]! <= businessCapacity ? "Business" : "Economy") : "N/A";
                                    int seatCost = widget.bookingCardData.status != "Waitlisted" && seats.containsKey(passenger) ? (seats[passenger]! <= businessCapacity ? 300 : 150) : 0;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 120, child: Text(passenger)),
                                          SizedBox(width: 60, child: Text(seatType, textAlign: TextAlign.center)),
                                          SizedBox(width: 60, child: Text(seats.containsKey(passenger) ? "Seat ${seats[passenger]}" : "N/A", textAlign: TextAlign.center)),
                                          SizedBox(width: 60, child: Text(seatCost == 0 ? "N/A" : "${seatCost.toString()} SAR", textAlign: TextAlign.right)),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Total Cost Section
                          const Text(
                            "Total",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Builder(
                              builder: (context) {
                                double totalCost = 0;

                                for (int i = 0; i < passengers.length; i++) {
                                  if (widget.bookingCardData.status == "Waitlisted" || !seats.containsKey(passengers[i])) {
                                    continue;
                                  }

                                  totalCost += seats[passengers[i]]! <= businessCapacity ? 300 : 150;
                                }

                                bool familyDiscount = false;

                                if (passengers.length > 1) {
                                  familyDiscount = true;
                                  totalCost *= 0.75;
                                }

                                return (totalCost != 0
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            familyDiscount ? "Family Discount: 25%" : "No Discount",
                                            style: const TextStyle(fontSize: 18),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            "${totalCost.toString()} SAR",
                                            style: const TextStyle(fontSize: 18),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      )
                                    : const Text("N/A"));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // back button and confirm button
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("BACK", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  (widget.bookingCardData.status == "Cancelled" || widget.bookingCardData.isDependent
                      ? const SizedBox.shrink()
                      : (Row(
                          children: [
                            (widget.bookingCardData.status == "Temp"
                                ? (Expanded(
                                    child: ElevatedButton(
                                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                                      onPressed: () async {
                                        // PAY (delete from temp_booking and insert into paid_booking, do this for the dependents too)
                                        var depenendsQuery = await dbModel.conn.execute("SELECT * FROM booking WHERE DependsOn_ReservationNo = ${widget.bookingCardData.reservationNo}");

                                        var reservationNumbers = [widget.bookingCardData.reservationNo, ...depenendsQuery.rows.map((row) => row.colByName("ReservationNo")!)];

                                        for (var resNo in reservationNumbers) {
                                          await dbModel.conn.execute("DELETE FROM temp_booking WHERE ReservationNo = $resNo");
                                          await dbModel.conn.execute("INSERT INTO paid_booking (ReservationNo, PaymentID) VALUES ($resNo, 1)");
                                        }

                                        showSnackBar(context, "Booking paid.");
                                        Navigator.pop(context);
                                      },
                                      child: const Text("PAY", style: TextStyle(color: Colors.white)),
                                    ),
                                  ))
                                : const SizedBox.shrink()),
                            (widget.bookingCardData.status == "Waitlisted"
                                ? (Expanded(
                                    child: ElevatedButton(
                                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                                      onPressed: () async {
                                        // PROMOTE (delete from waitlisted_booking and insert into listed_booking and temp_booking)
// For this train, get the number of seats in business and economy class
// On this date, get all reservations for this train
// Find any available seats
// If there are available seats, insert into listed_booking and temp_booking for this reservation and the dependents
// If there are no available seats, display a message and do nothing

                                        var train = await dbModel.conn.execute("SELECT * FROM train WHERE ID = ${widget.bookingCardData.trainID}");
                                        var trainID = widget.bookingCardData.trainID;
                                        var date = widget.bookingCardData.date;

                                        var allReservations = await dbModel.conn.execute("SELECT * FROM booking WHERE On_ID = $trainID AND Date = '$date' AND NOT EXISTS (SELECT 1 FROM cancelled_booking cb WHERE cb.ReservationNo = ReservationNo)");

                                        var availableSeats = List.generate(businessCapacity + economyCapacity, (index) => index + 1);

                                        for (var reservation in allReservations.rows) {
                                          var seatNumberQuery = await dbModel.conn.execute("SELECT * FROM listed_booking WHERE ReservationNo = ${reservation.colByName("ReservationNo")}");
                                          if (seatNumberQuery.rows.isNotEmpty) {
                                            availableSeats.remove(int.parse(seatNumberQuery.rows.first.colByName("SeatNumber")!));
                                          }
                                        }

                                        if (availableSeats.isEmpty || availableSeats.length < passengers.length) {
                                          showSnackBar(context, "No available seats.");
                                        } else {
                                          var depenendsQuery = await dbModel.conn.execute("SELECT * FROM booking WHERE DependsOn_ReservationNo = ${widget.bookingCardData.reservationNo}");

                                          var reservationNumbers = [widget.bookingCardData.reservationNo, ...depenendsQuery.rows.map((row) => row.colByName("ReservationNo")!)];

                                          for (var resNo in reservationNumbers) {
                                            var seatNumber = availableSeats.removeAt(0);
                                            await dbModel.conn.execute("DELETE FROM waitlisted_booking WHERE ReservationNo = $resNo");
                                            await dbModel.conn.execute("INSERT INTO listed_booking VALUES ($resNo, $seatNumber)");
                                            await dbModel.conn.execute("INSERT INTO temp_booking VALUES ($resNo, '2025-01-01')");
                                          }

                                          showSnackBar(context, "Booking promoted to temp (awaiting payment).");
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("PROMOTE", style: TextStyle(color: Colors.white)),
                                    ),
                                  ))
                                : const SizedBox.shrink()),
                            (["Waitlisted", "Temp"].contains(widget.bookingCardData.status) ? const SizedBox(width: 10) : const SizedBox.shrink()),
                            Expanded(
                              child: ElevatedButton(
                                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
                                onPressed: () async {
                                  // CANCEL for this reservation and the dependents
                                  var depenendsQuery = await dbModel.conn.execute("SELECT * FROM booking WHERE DependsOn_ReservationNo = ${widget.bookingCardData.reservationNo}");

                                  var reservationNumbers = [widget.bookingCardData.reservationNo, ...depenendsQuery.rows.map((row) => row.colByName("ReservationNo")!)];

                                  for (var resNo in reservationNumbers) {
                                    await dbModel.conn.execute("INSERT INTO cancelled_booking VALUES ($resNo, 0)");
                                  }

                                  showSnackBar(context, "Booking cancelled.");
                                  Navigator.pop(context);
                                },
                                child: const Text("CANCEL", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ))),
                ],
              ),
            )),
    );
  }
}
