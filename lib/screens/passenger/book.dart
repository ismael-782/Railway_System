import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/cards/train_card.dart";
import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class Booking extends StatefulWidget {
  final int trainID;
  final String source;
  final String destination;
  final String date;
  final TrainCardData trainCardData;

  const Booking(
      {super.key,
      required this.trainID,
      required this.source,
      required this.destination,
      required this.date,
      required this.trainCardData});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List<String> dependents = [];
  List<int> reservedSeats = [];
  String depId = "";
  int step = 0;
  int milesTravelled = 0;

  Map<int, int> seats = {};
  int currentPassenger = 0;

  TextEditingController depIdController = TextEditingController();

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var userModel = context.read<UserModel>();
    var dbModel = context.read<DBModel>();
    var seats = await dbModel.conn.execute("""
SELECT SeatNumber
FROM booking b NATURAL JOIN listed_booking lb
WHERE On_ID='${widget.trainID}' AND DATE='${widget.date}'""");

    reservedSeats =
        seats.rows.map((r) => int.parse(r.colByName("SeatNumber")!)).toList();

    var query = await dbModel.conn
        .execute("SELECT * FROM passenger WHERE ID = ${userModel.id()}");
    milesTravelled = int.parse(query.rows
        .toList()
        .map((row) => row.colByName("MilesTravelled")!)
        .first);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();
    var dbModel = context.watch<DBModel>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(200), // Custom height for the AppBar
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
                padding: const EdgeInsets.only(
                    top: 20.0), // Adjust padding if needed
                child: TrainCard(
                  trainCardData:
                      widget.trainCardData, // Include your TrainCard widget
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
                  "Write your dependents IDs",
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
                        controller: depIdController,
                        decoration: InputDecoration(
                          labelText: "Dependent ID",
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        onChanged: (value) {
                          setState(() {
                            depId = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(60, 50),
                      ),
                      onPressed: () async {
                        if (depId == "") {
                          return showSnackBar(
                              context, "Please input a dependent ID.");
                        }
                        if (dependents.contains(depId)) {
                          return showSnackBar(
                              context, "Dependent already added.");
                        }
                        if (depId == userModel.id()) {
                          return showSnackBar(context,
                              "You cannot add yourself as a dependent.");
                        }
                        setState(() {
                          dependents.add(depId);
                          depId = "";
                          depIdController.clear();
                          showSnackBar(context, "Dependent added.");
                        });
                      },
                      child: const Text("Add",
                          style: TextStyle(color: Colors.white)),
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
                      itemCount: dependents.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
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
                                "ID: ${dependents[index]}",
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
                                    dependents.removeAt(index);
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
                            borderRadius: BorderRadius.circular(15),
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
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
                                    currentPassenger = (currentPassenger - 1) %
                                        (dependents.length + 1);
                                  });
                                },
                    ),
                    Text(
                      currentPassenger == 0
                          ? userModel.id()
                          : dependents[currentPassenger - 1],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed:
                          // if not possible, set this to null
                          currentPassenger == dependents.length
                              ? null
                              : () {
                                  setState(() {
                                    currentPassenger = (currentPassenger + 1) %
                                        (dependents.length + 1);
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
                      color: Colors.grey[200],
                    ),
                    const SizedBox(width: 10),
                    const Text("Reserved", style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 400,
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    // FIXME: Use EconomyCapacity and BusinessCapacity from the database instead of fixed values
                    itemCount: 28,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: GestureDetector(
                          onTap: reservedSeats.contains(index + 1)
                              ? null
                              : () {
                                  setState(() {
                                    if (seats[currentPassenger] == index + 1) {
                                      seats.remove(currentPassenger);
                                    } else {
                                      seats[currentPassenger] = index + 1;
                                    }
                                  });
                                },
                          child: Container(
                            // set size of chair to be smaller
                            margin: const EdgeInsets.only(
                                right: 5, top: 5, bottom: 5, left: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      index < 8 ? Colors.amber : Colors.blue),
                              borderRadius: BorderRadius.circular(5),
                              color: (reservedSeats.contains(index + 1)
                                  ? Colors.grey[200]
                                  : (seats.values.contains(index + 1)
                                      ? (index < 8
                                          ? Colors.amber[200]
                                          : Colors.blue[200])
                                      : const Color(0x00fff7fe))),
                            ),
                            child: Center(
                              child: Text(
                                (index + 1).toString().padLeft(2, "0"),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.black)),
                        onPressed: () {
                          setState(() {
                            step = 0;
                          });
                        },
                        child: const Text("BACK",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.black)),
                        onPressed: () {
                          if (seats.length < dependents.length + 1) {
                            return showSnackBar(context,
                                "Please select a seat for each passenger.");
                          }

                          setState(() {
                            step = 2;
                          });
                        },
                        child: const Text("NEXT",
                            style: TextStyle(color: Colors.white)),
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
                    SizedBox(width: 10),
                    Text(
                      "Booking Summary",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  "Train ID: ${widget.trainID}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Date: ${widget.date}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Source: ${widget.source}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Destination: ${widget.destination}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Passengers:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...List.generate(dependents.length + 1, (index) {
                  String passenger =
                      index == 0 ? userModel.id() : dependents[index - 1];
                  String seatType = seats[index]! < 9 ? "Business" : "Economy";
                  int seatCost = seats[index]! < 9 ? 300 : 150;

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
                      totalCost += seats[i]! < 9 ? 300 : 150;
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
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.black)),
                        onPressed: () {
                          setState(() {
                            step = 1;
                          });
                        },
                        child: const Text("BACK",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.black)),
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
                              var result = await dbModel.conn.execute(
                                  "SELECT * FROM passenger WHERE ID = '${dependents[i - 1]}'");

                              if (result.rows.isEmpty) {
                                await dbModel.conn.execute(
                                    "INSERT INTO user (ID, Password) VALUES ('${dependents[i - 1]}', NULL)");
                                await dbModel.conn.execute(
                                    "INSERT INTO passenger (ID, MilesTravelled) VALUES ('${dependents[i - 1]}', 0)");
                              }
                            }
                            await dbModel.conn.execute("""
    INSERT INTO booking (Date, Coach, On_ID, StartsAt_Name, EndsAt_Name, DependsOn_ReservationNo, BelongsTo_ID)
    VALUES ('${widget.date}', '${seats[i]! < 9 ? "Business" : "Economy"}', '${widget.trainID}', '${widget.source}', '${widget.destination}', NULL, '${i == 0 ? userModel.id() : dependents[i - 1]}');
    """);

                            var result = await dbModel.conn.execute(
                                "SELECT MAX(ReservationNo) FROM booking");
                            int reservationNo =
                                int.parse(result.rows.first.colAt(0)!);

                            await dbModel.conn.execute("""
    INSERT INTO listed_booking (ReservationNo, SeatNumber)
    VALUES ($reservationNo, ${seats[i]});
    """);
                          }

                          showSnackBar(context, "Booking confirmed.");
                          Navigator.pop(context);
                        },
                        child: const Text("CONFIRM",
                            style: TextStyle(color: Colors.white)),
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
