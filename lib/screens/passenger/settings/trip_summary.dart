// TODO: Change the design to the new design in book.dart
import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/data/booking_card_data.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/screens/passenger/cards/coming_trip_card.dart";

class TripSummaryPage extends StatefulWidget {
  final BookingCardData bookingCardData;

  const TripSummaryPage({super.key, required this.bookingCardData});

  @override
  State<TripSummaryPage> createState() => _TripSummaryPageState();
}

class _TripSummaryPageState extends State<TripSummaryPage> {
  List<String> passengers = [];
  Map<String, int> seats = {};
  int businessCapacity = 0;
  int economyCapacity = 0;
  int milesTravelled = 0;

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var userModel = context.read<UserModel>();
    var dbModel = context.read<DBModel>();

    // Read the dependents of this booking based on the reservation number from BookingCardData
    // For each dependent and the user, read their seat number from listed_booking table SeatNumber

    var allPassengers = await dbModel.conn.execute("SELECT * FROM booking NATURAL JOIN listed_booking WHERE DependsOn_ReservationNo = ${widget.bookingCardData.reservationNo} OR ReservationNo = ${widget.bookingCardData.reservationNo}");

    // loop through allPassengers and add them to dependents and seats
    for (var passenger in allPassengers.rows) {
      String passengerID = passenger.colByName("BelongsTo_ID")!;
      int seatNumber = int.parse(passenger.colByName("SeatNumber")!);

      passengers.add(passengerID);
      seats[passengerID] = seatNumber;
    }

    // Get the business and economy capacity of the train
    var train = await dbModel.conn.execute("SELECT * FROM train WHERE ID = ${widget.bookingCardData.trainID}");
    businessCapacity = int.parse(train.rows.first.colByName("BusinessCapacity")!);
    economyCapacity = int.parse(train.rows.first.colByName("EconomyCapacity")!);

    // Get the miles travelled by the user
    var miles = await dbModel.conn.execute("SELECT * FROM passenger WHERE ID = ${userModel.id()}");
    milesTravelled = int.parse(miles.rows.first.colByName("MilesTravelled")!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                    Text( //widget.bookingCardData.trainID
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
                                String seatType = seats[passenger]! <= businessCapacity ? "Business" : "Economy";
                                int seatCost = seats[passenger]! <= businessCapacity ? 300 : 150;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 120, child: Text(passenger)),
                                        SizedBox(width: 60, child: Text(seatType, textAlign: TextAlign.center)),
                                        SizedBox(width: 60, child: Text("Seat ${seats[passenger]}", textAlign: TextAlign.center)),
                                        SizedBox(width: 60, child: Text("${seatCost.toString()} SAR", textAlign: TextAlign.right)),
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
                        totalCost += seats[passengers[i]]! <= businessCapacity ? 300 : 150;
                      }

                      bool familyDiscount = false;
                      String? milesDiscount;

                      if (passengers.length > 1) {
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
                ],
              ),
            )),
    );
  }
}