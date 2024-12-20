import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/cards/search_trip_card.dart";
import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class StaffBooking extends StatefulWidget {
  final int trainID;
  final String source;
  final String destination;
  final String date;
  final TrainCardData trainCardData;

  const StaffBooking({super.key, required this.trainID, required this.source, required this.destination, required this.date, required this.trainCardData});

  @override
  State<StaffBooking> createState() => _StaffBookingState();
}

class _StaffBookingState extends State<StaffBooking> {
  List<String> passengers = [];
  List<int> reservedSeats = [];
  String passengerId = "";
  int step = 0;

  Map<int, int> seats = {};
  int currentPassenger = 0;

  TextEditingController passengerIdController = TextEditingController();

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();
    var seats = await dbModel.conn.execute("""
SELECT SeatNumber
FROM booking b NATURAL JOIN listed_booking lb
WHERE On_ID='${widget.trainID}' AND DATE='${widget.date}' AND NOT EXISTS (SELECT 1 FROM cancelled_booking cb WHERE cb.ReservationNo = b.ReservationNo)
    """);

    reservedSeats = seats.rows.map((r) => int.parse(r.colByName("SeatNumber")!)).toList();

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
                child: SearchTripCard(
                  trainCardData: widget.trainCardData, // Include your TrainCard widget
                  clickable: false,
                ),
              ),
              centerTitle: true, // Align the TrainCard widget in the center
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: switch (step) {
          0 => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input field and Add button
                const Text(
                  "Write your passengers IDs",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLength: 10,
                        buildCounter: null,
                        controller: passengerIdController,
                        decoration: InputDecoration(
                          counter: null,
                          counterText: "",
                          labelText: "Passenger ID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        ),
                        onChanged: (value) {
                          setState(() {
                            passengerId = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(60, 50),
                      ),
                      onPressed: () async {
                        if (passengerId == "") {
                          return showSnackBar(context, "Please input a passenger ID.");
                        }
                        if (passengers.contains(passengerId)) {
                          return showSnackBar(context, "Passenger already added.");
                        }

                        setState(() {
                          passengers.add(passengerId);
                          passengerId = "";
                          passengerIdController.clear();
                          showSnackBar(context, "Passenger added.");
                        });
                      },
                      child: const Text("Add", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Dependents List
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: passengers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ID: ${passengers[index]}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 1, 1, 1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    passengers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Buttons
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            if (passengers.isEmpty) {
                              return showSnackBar(context, "Please add at least one passenger.");
                            }

                            step = 1;
                          });
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          1 => Column(
              // select seats, show 4 seats per row, 2 each side, 5 rows, blue border. then show 4 seats per row, 2 each side, 2 rows, gold border.
              // on top, show the name of the passenger, and then NEXT and BEFORE using arrow_back_ios and arrow_forward_ios to navigate between the passenger and dependents
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed:
                          // if not possible, set this to null
                          currentPassenger == 0
                              ? null
                              : () {
                                  setState(() {
                                    currentPassenger = (currentPassenger - 1);
                                  });
                                },
                    ),
                    Text(
                      "Seat for ID: ${passengers[currentPassenger]}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed:
                          // if not possible, set this to null
                          currentPassenger == passengers.length - 1
                              ? null
                              : () {
                                  setState(() {
                                    currentPassenger = (currentPassenger + 1);
                                  });
                                },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Economy seats (BLUE BORDER): 5 rows, 4 seats per row, 2 each side
                // XX XX
                // XX XX
                // XX XX
                // XX XX
                // XX XX
                // Business seats (GOLD border): 2 rows, 4 seats per row, 2 each side
                // XX XX
                // XX XX
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.amber[200],
                    ),
                    const SizedBox(width: 10),
                    const Text("Business", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 20),
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.blue[200],
                    ),
                    const SizedBox(width: 10),
                    const Text("Economy", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 20),
                    Container(
                      width: 20,
                      height: 20,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    const SizedBox(width: 10),
                    const Text("Reserved", style: TextStyle(fontSize: 16)),
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
                        offset: const Offset(5, 0),
                      ),
                    ],
                  ),
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GridView.builder(
                      // this is the starting of the Seates code
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Four seats per row
                        crossAxisSpacing: 10, // Space between columns
                        mainAxisSpacing: 10, // Space between rows
                        childAspectRatio: 1.2, // Adjust for the seat shape
                      ),
                      itemCount: widget.trainCardData.economyCapacity + widget.trainCardData.businessCapacity,
                      itemBuilder: (context, index) {
                        bool isBusinessClass = index < widget.trainCardData.businessCapacity;
                        bool isReserved = reservedSeats.contains(index + 1);
                        bool isSelected = seats.values.contains(index + 1);

                        return GestureDetector(
                          onTap: isReserved
                              ? null
                              : () {
                                  setState(() {
                                    if (seats[currentPassenger] == index + 1) {
                                      seats.remove(currentPassenger);
                                    } else {
                                      // return if seat is reserved by someone else on the same reservation
                                      if (seats.values.contains(index + 1)) {
                                        return showSnackBar(context, "Seat already selected by another passenger.");
                                      }

                                      seats[currentPassenger] = index + 1;
                                    }
                                  });
                                },
                          child: Container(
                            margin: const EdgeInsets.all(5.0), // Adjust spacing
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isBusinessClass ? Colors.amber : Colors.blue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              color: isReserved
                                  ? const Color.fromARGB(255, 2, 1, 1) // Reserved seat color
                                  : isSelected
                                      ? (isBusinessClass ? Colors.amber[300] : Colors.blue[300]) // Selected color
                                      : Colors.white, // Default seat color
                            ),
                            child: Center(
                              child: Text(
                                (index + 1).toString().padLeft(2, "0"), // Seat number
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isReserved ? const Color.fromARGB(255, 255, 255, 255) : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            step = 0;
                          });
                        },
                        child: const Text("BACK", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (seats.length != passengers.length) {
                            return showSnackBar(context, "Please select a seat for each passenger.");
                          }

                          setState(() {
                            step = 2;
                          });
                        },
                        child: const Text("NEXT", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          2 => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.confirmation_number_sharp),
                    SizedBox(width: 15),
                    Text(
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
                              Text("Date: ${widget.date}", style: const TextStyle(fontSize: 16)),
                              Text("Source: ${widget.source}", style: const TextStyle(fontSize: 16)),
                              Text("Destination: ${widget.destination}", style: const TextStyle(fontSize: 16)),
                              Text("Train Number: ${widget.trainID}", style: const TextStyle(fontSize: 16)),
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
                                  String seatType = seats[index]! <= widget.trainCardData.businessCapacity ? "Business" : "Economy";
                                  int seatCost = seats[index]! <= widget.trainCardData.businessCapacity ? 300 : 150;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 120, child: Text(passenger)),
                                        SizedBox(width: 60, child: Text(seatType, textAlign: TextAlign.center)),
                                        SizedBox(width: 60, child: Text("Seat ${seats[index]}", textAlign: TextAlign.center)),
                                        SizedBox(width: 60, child: Text("$seatCost SAR", textAlign: TextAlign.right)),
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
                                totalCost += seats[i]! <= widget.trainCardData.businessCapacity ? 300 : 150;
                              }

                              bool familyDiscount = false;

                              if (passengers.length > 1) {
                                familyDiscount = true;
                                totalCost *= 0.75;
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (familyDiscount ? const Text("Family Discount 25%", style: TextStyle(fontSize: 16)) : const SizedBox.shrink()),
                                  (familyDiscount == false ? const Text("No Discount", style: TextStyle(fontSize: 16)) : const SizedBox.shrink()),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${totalCost.toStringAsFixed(2)} SAR",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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

                          var passengerReservationNo = "";

                          for (int i = 0; i < passengers.length; i++) {
                            var result = await dbModel.conn.execute("SELECT * FROM passenger WHERE ID = '${passengers[i]}'");

                            if (result.rows.isEmpty) {
                              await dbModel.conn.execute("INSERT INTO user (ID, Password) VALUES ('${passengers[i]}', NULL)");
                              await dbModel.conn.execute("INSERT INTO passenger (ID, MilesTravelled) VALUES ('${passengers[i]}', 0)");
                            }

                            await dbModel.conn.execute("""
    INSERT INTO booking (Date, Coach, On_ID, StartsAt_Name, EndsAt_Name, DependsOn_ReservationNo, BelongsTo_ID)
    VALUES ('${widget.date}', '${seats[i]! <= widget.trainCardData.businessCapacity ? "Business" : "Economy"}', '${widget.trainID}', '${widget.source}', '${widget.destination}', ${i == 0 ? "NULL" : passengerReservationNo}, '${passengers[i]}');
    """);

                            // if i == 0 then store the insert's reservation number in a variable for dependents to use
                            if (i == 0) {
                              var result = await dbModel.conn.execute("SELECT MAX(ReservationNo) FROM booking");
                              passengerReservationNo = result.rows.first.colAt(0)!;
                            }

                            result = await dbModel.conn.execute("SELECT MAX(ReservationNo) FROM booking");
                            int reservationNo = int.parse(result.rows.first.colAt(0)!);

                            await dbModel.conn.execute("""
    INSERT INTO listed_booking (ReservationNo, SeatNumber)
    VALUES ($reservationNo, ${seats[i]});
    """);

                            await dbModel.conn.execute("INSERT INTO temp_booking VALUES ($reservationNo, '2025-01-01')");
                          }

                          showSnackBar(context, "Booking confirmed (Reservation #$passengerReservationNo).");
                          Navigator.pop(context);
                        },
                        child: const Text("Pay Later", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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

                          double totalCost = 0;

                          for (int i = 0; i < passengers.length; i++) {
                            totalCost += seats[i]! <= widget.trainCardData.businessCapacity ? 300 : 150;
                          }

                          if (passengers.length > 1) {
                            totalCost *= 0.75;
                          }

                          await dbModel.conn.execute("INSERT INTO payment (Amount) VALUES ($totalCost)");

                          var lastPayment = await dbModel.conn.execute("SELECT MAX(ID) FROM payment");

                          var passengerReservationNo = "";

                          for (int i = 0; i < passengers.length; i++) {
                            var result = await dbModel.conn.execute("SELECT * FROM passenger WHERE ID = '${passengers[i]}'");

                            if (result.rows.isEmpty) {
                              await dbModel.conn.execute("INSERT INTO user (ID, Password) VALUES ('${passengers[i]}', NULL)");
                              await dbModel.conn.execute("INSERT INTO passenger (ID, MilesTravelled) VALUES ('${passengers[i]}', 0)");
                            }

                            await dbModel.conn.execute("""
    INSERT INTO booking (Date, Coach, On_ID, StartsAt_Name, EndsAt_Name, DependsOn_ReservationNo, BelongsTo_ID)
    VALUES ('${widget.date}', '${seats[i]! <= widget.trainCardData.businessCapacity ? "Business" : "Economy"}', '${widget.trainID}', '${widget.source}', '${widget.destination}', ${i == 0 ? "NULL" : passengerReservationNo}, '${passengers[i]}');
    """);

                            // if i == 0 then store the insert's reservation number in a variable for dependents to use
                            if (i == 0) {
                              var result = await dbModel.conn.execute("SELECT MAX(ReservationNo) FROM booking");
                              passengerReservationNo = result.rows.first.colAt(0)!;
                            }

                            result = await dbModel.conn.execute("SELECT MAX(ReservationNo) FROM booking");
                            int reservationNo = int.parse(result.rows.first.colAt(0)!);

                            await dbModel.conn.execute("""
    INSERT INTO listed_booking (ReservationNo, SeatNumber)
    VALUES ($reservationNo, ${seats[i]});
    """);

                            await dbModel.conn.execute("INSERT INTO paid_booking (ReservationNo, PaymentID) VALUES ($reservationNo, ${lastPayment.rows.first.colAt(0)})");
                          }

                          showSnackBar(context, "Booking confirmed (Reservation #$passengerReservationNo).");
                          Navigator.pop(context);
                        },
                        child: const Text("Pay Now", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          int() => const SizedBox.shrink(),
        },
      ),
    );
  }
}
