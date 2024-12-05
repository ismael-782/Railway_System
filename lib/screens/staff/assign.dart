import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class StaffAssign extends StatefulWidget {
  const StaffAssign({super.key});

  @override
  State<StaffAssign> createState() => _StaffAssignState();
}

class _StaffAssignState extends State<StaffAssign> {
  Map<String, String> staff = {};
  Map<int, TrainData> trains = {};
  String? currentAssigned;
  int? activeTrain;

  int selectedTrainID = 1;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  final List<String> months = List.generate(12, (index) => (index + 1).toString());
  final List<String> years = List.generate(2, (index) => (DateTime.now().year + index).toString());

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();

    var query = await dbModel.conn.execute("SELECT * FROM train");

    for (var row in query.rows) {
      trains[int.parse(row.colByName("ID")!)] = TrainData(
        trainID: int.parse(row.colByName("ID")!),
        nameEN: row.colByName("NameEN")!,
        nameAR: row.colByName("NameAR")!,
        source: row.colByName("StartsAt_Name")!,
        destination: row.colByName("EndsAt_Name")!,
      );
    }

    query = await dbModel.conn.execute("SELECT * FROM user NATURAL JOIN staff");

    for (var row in query.rows) {
      staff[row.colByName("ID")!] = row.colByName("Name")!;
    }

    setState(() {});
  }

  List<String> createDaysList(String? month) {
    if (month == null) {
      return [];
    }

    int daysInMonth = 31;

    if (["4", "6", "9", "11"].contains(month)) {
      daysInMonth = 30;
    } else if (month == "2") {
      daysInMonth = 28;
    }

    return List.generate(daysInMonth, (index) => (index + 1).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  flex: 1,
                  child: Text("Train ID", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(flex: 2, child: Text("Date", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      DropdownButton<int>(
                        hint: const Text("Train ID"),
                        value: selectedTrainID,
                        items: trains.keys.map((int trainID) {
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
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      DropdownButton<String>(
                        hint: const Text("Month"),
                        value: selectedMonth,
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMonth = newValue;
                            activeTrain = null;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        hint: const Text("Day"),
                        value: selectedDay,
                        items: createDaysList(selectedMonth).map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: selectedMonth == null
                            ? null
                            : (String? newValue) {
                                setState(() {
                                  selectedDay = newValue;
                                  activeTrain = null;
                                });
                              },
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        hint: const Text("Year"),
                        value: selectedYear,
                        items: years.map((String year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedYear = newValue;
                            activeTrain = null;
                          });
                        },
                      )
                    ]))
              ]),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (selectedDay == null || selectedMonth == null || selectedYear == null) {
                            return showSnackBar(context, "Please fill all fields");
                          }

                          var dbModel = context.read<DBModel>();

                          var query = await dbModel.conn.execute("SELECT * FROM responsible_of WHERE TrainID = $selectedTrainID AND Date = '$selectedYear-$selectedMonth-$selectedDay'");

                          if (query.rows.isNotEmpty) {
                            currentAssigned = query.rows.first.colByName("StaffID");
                          } else {
                            currentAssigned = null;
                          }

                          setState(() {
                            activeTrain = selectedTrainID;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "GET TRAIN",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      const SizedBox(height: 35),
      (activeTrain == null
          ? const SizedBox.shrink()
          : Column(
              children: [
                TrainCard(trainData: trains[activeTrain!]!),
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

class TrainData {
  final int trainID;
  final String nameEN;
  final String nameAR;
  final String source;
  final String destination;

  TrainData({
    required this.trainID,
    required this.nameEN,
    required this.nameAR,
    required this.source,
    required this.destination,
  });
}

class TrainCard extends StatelessWidget {
  final TrainData trainData;

  const TrainCard({super.key, required this.trainData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 180,
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), border: Border.all(color: Colors.blue, width: 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Spacer(),
              const Icon(Icons.train),
              const SizedBox(width: 5),
              Text("Train #${trainData.trainID}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const Spacer(),
              Column(children: [Text(trainData.nameEN), Text(trainData.nameAR)]),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(trainData.source, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 45),
              const Icon(Icons.arrow_forward),
              const SizedBox(width: 45),
              Text(trainData.destination, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
