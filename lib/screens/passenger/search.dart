import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

class PassengerSearch extends StatefulWidget {
  const PassengerSearch({super.key});

  @override
  State<PassengerSearch> createState() => _PassengerSearchState();
}

class _PassengerSearchState extends State<PassengerSearch> {
  Map<String, List<String>> destinationsFromSource = {};
  List<String> stations = [];

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
                            width: 180,
                            initialSelection: source,
                            dropdownMenuEntries: stations.map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(value: value, label: value);
                            }).toList(),
                            onSelected: (value) async {
                              setState(() {
                                source = value!;
                              });
                            },
                          ),
                          const Spacer(),
                          DropdownMenu<String>(
                            hintText: "Destination",
                            width: 180,
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
                          print("Looking for trains from $source to $destination on $selectedDay/$selectedMonth/$selectedYear");
                        },
                        child: const Text("SEARCH", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
  }
}
