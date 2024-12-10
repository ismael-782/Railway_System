import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/staff/cards/staff_search_trip_card.dart";
import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class StaffAssign extends StatefulWidget {
  const StaffAssign({super.key});

  @override
  State<StaffAssign> createState() => _StaffAssignState();
}

class _StaffAssignState extends State<StaffAssign> {
  Map<String, String> staff = {};
  List<int> trainIDs = [];
  String? currentAssigned;

  int? activeTrain;
  TrainCardData? activeTrainData;

  int selectedTrainID = 1;

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  DateTime? selectedDate;

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();

    var query = await dbModel.conn.execute("SELECT * FROM train");

    for (var row in query.rows) {
      trainIDs.add(int.parse(row.colByName("ID")!));
    }

    query = await dbModel.conn.execute("SELECT * FROM user NATURAL JOIN staff");

    for (var row in query.rows) {
      staff[row.colByName("ID")!] = row.colByName("Name")!;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "Select a Train",
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
                      "Train ID",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text("Train ID"),
                        value: selectedTrainID,
                        items: trainIDs.map((int trainID) {
                          return DropdownMenuItem<int>(
                            value: trainID,
                            child: Text("Train #$trainID"),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue == null) return;

                          setState(() {
                            selectedTrainID = newValue;
                            activeTrain = null;
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
                        activeTrain = null;

                        selectedDay = pickedDate.day.toString().padLeft(2, "0");
                        selectedMonth = pickedDate.month.toString().padLeft(2, "0");
                        selectedYear = pickedDate.year.toString();
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

                      var dbModel = context.read<DBModel>();

                      var query = await dbModel.conn.execute("SELECT * FROM responsible_of WHERE TrainID = $selectedTrainID AND Date = '$selectedYear-$selectedMonth-$selectedDay'");

                      if (query.rows.isNotEmpty) {
                        currentAssigned = query.rows.first.colByName("StaffID");
                      } else {
                        currentAssigned = null;
                      }

                      /* TrainCardData consists of : 
  final int trainID;
  final String nameEN;
  final String nameAR;
  final String source;
  final String destination;
  final String date;
  final int sTime;
  final int fTime;
  final int businessCapacity;
  final int economyCapacity;
  final int bookedBusiness;
  final int bookedEconomy;
                      */

                      var searchResult = (await dbModel.conn.execute("""
    SELECT 
        pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
    FROM
        passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
            JOIN train t ON pt1.TrainID = t.ID
    WHERE
        pt1.TrainID = $selectedTrainID AND pt1.StationName = t.StartsAt_Name AND pt2.StationName = t.EndsAt_Name AND pt1.SequenceNo < pt2.SequenceNo 
    ORDER BY pt1.TrainID, pt1.SequenceNo;
  """)).rows.toList();

                      var bookings = (await dbModel.conn.execute("""
    SELECT *
    FROM booking NATURAL JOIN listed_booking
    WHERE
    Date = '$selectedYear-$selectedMonth-$selectedDay'
  """)).rows.toList();

                      var row = searchResult.first;

                      activeTrainData = TrainCardData(
                        trainID: int.parse(row.colByName("TrainID")!),
                        nameEN: row.colByName("NameEN")!,
                        nameAR: row.colByName("NameAR")!,
                        source: row.colByName("StartsAt_Name")!,
                        destination: row.colByName("EndsAt_Name")!,
                        date: "$selectedYear-$selectedMonth-$selectedDay",
                        sTime: int.parse(row.colByName("S_Time")!),
                        fTime: int.parse(row.colByName("F_Time")!),
                        businessCapacity: int.parse(row.colByName("BusinessCapacity")!),
                        economyCapacity: int.parse(row.colByName("EconomyCapacity")!),
                        bookedBusiness: bookings.where((booking) => booking.colByName("On_ID") == row.colByName("TrainID") && booking.colByName("Coach") == "Business").length,
                        bookedEconomy: bookings.where((booking) => booking.colByName("On_ID") == row.colByName("TrainID") && booking.colByName("Coach") == "Economy").length,
                      );

                      setState(() {
                        activeTrain = selectedTrainID;
                      });
                    },
                    child: const Text(
                      "GET TRAIN",
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
      const SizedBox(height: 35),
      (activeTrain == null || activeTrainData == null
          ? const SizedBox.shrink()
          : Column(
              children: [
                StaffSearchTripCard(trainCardData: activeTrainData!, clickable: false),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  hint: const Text("Select Staff"),
                  value: currentAssigned,
                  items: staff.keys.map((String staffID) {
                    return DropdownMenuItem<String>(
                      value: staffID,
                      child: Text("${staff[staffID]} ($staffID)"),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    if (newValue == null) return;

                    currentAssigned = newValue;

                    var dbModel = context.read<DBModel>();

                    await dbModel.conn.execute("""
  INSERT INTO responsible_of (TrainID, Date, StaffID) VALUES($selectedTrainID, '$selectedYear-$selectedMonth-$selectedDay', '$currentAssigned') ON DUPLICATE KEY UPDATE    
StaffID = '$currentAssigned'
""");

                    showSnackBar(context, "Staff assigned successfully");

                    setState(() {});
                  },
                )
              ],
            ))
    ]);
  }
}
