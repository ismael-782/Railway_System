import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

class Passenger extends StatefulWidget {
  const Passenger({super.key});

  @override
  State<Passenger> createState() => _PassengerState();
}

class _PassengerState extends State<Passenger> {
  Map<String, List<String>> destinationsFromSource = {};
  List<String> stations = [];

  String source = "";
  String destination = "";

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();
    var stationQuery = await dbModel.conn.execute("SELECT * FROM station");

    stations = stationQuery.rows.toList().map((row) => row.colByName("Name")!).toList();
    source = stations[0];

    var connectedToQuery = await dbModel.conn.execute("SELECT * FROM connected_to");

    for (var station in stations) {
      var connectedStations = connectedToQuery.rows.toList().where((row) => row.colByName("Station1") == station).map((row) => row.colByName("Station2")!).toList();

      var destinations = List<String>.from(connectedStations);

      List<String> additionalDestinations = [];
      for (var connectedStation in connectedStations) {
        additionalDestinations.addAll(connectedToQuery.rows
            .toList()
            .where((row) => row.colByName("Station1") == connectedStation)
            .map((row) => row.colByName("Station2")!)
            .where((dest) => dest != station) // Exclude the station itself
            .toList());
      }

      destinations.addAll(additionalDestinations);
      destinationsFromSource[station] = destinations.toSet().toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownMenu<String>(
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
                    width: 180,
                    initialSelection: source == "" ? "" : destinationsFromSource[source]![0],
                    dropdownMenuEntries: source == ""
                        ? []
                        : destinationsFromSource[source]!.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(value: value, label: value);
                          }).toList(),
                    onSelected: (value) async {
                      print("Looking for trains from $source to $value");
                    },
                  )
                ],
              ),
              DatePickerDialog(firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30))),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                child: const Text("LOGOUT", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  userModel.logout();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
