import "package:mysql_client/mysql_client.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/booking.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class PassengerSearch extends StatefulWidget {
  const PassengerSearch({super.key});

  @override
  State<PassengerSearch> createState() => _PassengerSearchState();
}

class _PassengerSearchState extends State<PassengerSearch> {
  Map<String, List<String>> destinationsFromSource = {};
  List<String> stations = [];

  List<ResultSetRow> searchResult = [];

  String source = "";
  String destination = "";

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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbModel = context.watch<DBModel>();

    return (source == ""
        ? Center(child: CircularProgressIndicator(color: Colors.blue[300]))
        : Column(
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(3.0)), border: Border.all(color: Colors.blue, width: 2)),
                height: 240,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Source", style: TextStyle(fontWeight: FontWeight.bold)),
                          Spacer(),
                          Text("Destination", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          DropdownMenu<String>(
                            hintText: "Source",
                            initialSelection: source,
                            dropdownMenuEntries: stations.map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(value: value, label: value);
                            }).toList(),
                            onSelected: (value) async {
                              setState(() {
                                source = value!;
                                destination = destinationsFromSource[source]![0];
                              });
                            },
                          ),
                          const Spacer(),
                          DropdownMenu<String>(
                            hintText: "Destination",
                            initialSelection: source == "" ? "" : destinationsFromSource[source]![0],
                            dropdownMenuEntries: source == ""
                                ? []
                                : destinationsFromSource[source]!.map<DropdownMenuEntry<String>>((String value) {
                                    return DropdownMenuEntry<String>(value: value, label: value);
                                  }).toList(),
                            onSelected: (value) async {
                              setState(() {
                                destination = value!;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                            });
                          },
                        )
                      ]),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                        onPressed: () async {
                          if (selectedDay == null || selectedMonth == null || selectedYear == null) {
                            showSnackBar(context, "Please select a date.");
                            return;
                          }

// FIXME: You cannot reserve trains that are in the same today
                          if (DateTime.now().isAfter(DateTime(int.parse(selectedYear!), int.parse(selectedMonth!), int.parse(selectedDay!)))) {
                            showSnackBar(context, "Please select a future date.");
                            return;
                          }

                          searchResult = (await dbModel.conn.execute("""
SELECT 
    pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
FROM
    passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
                        JOIN train t ON pt1.TrainID = t.ID
WHERE
    pt1.StationName = '$source' AND pt2.StationName = '$destination' AND pt1.SequenceNo < pt2.SequenceNo ORDER BY pt1.TrainID , pt1.SequenceNo;
                          """)).rows.toList();

                          setState(() {});
                        },
                        child: const Text("SEARCH", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              (searchResult == []
                  ? (const SizedBox.shrink())
                  : Expanded(
                      child: (ListView(
                        children: searchResult.map((ResultSetRow train) {
                          return (Column(children: [
                            TrainCard(train: train, source: source, destination: destination, date: "$selectedYear-$selectedMonth-$selectedDay"),
                            const SizedBox(height: 10),
                          ]));
                        }).toList(),
                      )),
                    )),
            ],
          ));
  }
}

class TrainCard extends StatelessWidget {
  final ResultSetRow train;
  final String source;
  final String destination;
  final String date;

  const TrainCard({super.key, required this.train, required this.source, required this.destination, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 180,
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), border: Border.all(color: Colors.blue, width: 2)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Booking(
                trainID: train.colByName("TrainID")!,
                source: source,
                destination: destination,
                date: date,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    const Icon(Icons.train),
                    const SizedBox(width: 5),
                    Text("Train #${train.colByName("TrainID")!}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const Spacer(),
                    Column(children: [Text(train.colByName("NameEN")!), Text(train.colByName("NameAR")!)]),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(minutesToTime(int.parse(train.colByName("S_Time")!))),
                    const SizedBox(width: 10),
                    const Text("- - - - - - - "),
                    const Icon(Icons.arrow_forward),
                    const Text("- - - - - - - "),
                    const SizedBox(width: 10),
                    Text(minutesToTime(int.parse(train.colByName("F_Time")!))),
                  ],
                ),
                const SizedBox(height: 15),
                Text(minutesToDuration(int.parse(train.colByName("F_Time")!) - int.parse(train.colByName("S_Time")!))),
              ],
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
