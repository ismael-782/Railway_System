import "package:mysql_client/mysql_client.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/cards/train_card.dart";
import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class PassengerSearch extends StatefulWidget {
  const PassengerSearch({super.key});

  @override
  State<PassengerSearch> createState() => _PassengerSearchState();
}

class _PassengerSearchState extends State<PassengerSearch> {
  Map<String, List<String>> destinationsFromSource = {}; // Given a source, return the possible destinations
  List<String> stations = []; // All stations (possible sources)

  List<TrainCardData> cardsData = []; // Search results

  String source = "";
  String destination = "";

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

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

    return Scaffold(
        appBar: AppBar(),
        body: (source == ""
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
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year + 1),
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedYear = value.year.toString();
                                        selectedMonth = value.month.toString();
                                        selectedDay = value.day.toString();
                                      });
                                    }
                                  });
                                },
                                child: const Text("Select Date", style: TextStyle(color: Colors.white))),
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

                              var searchResult = (await dbModel.conn.execute("""
SELECT 
    pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
FROM
    passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
                        JOIN train t ON pt1.TrainID = t.ID
WHERE
    pt1.StationName = '$source' AND pt2.StationName = '$destination' AND pt1.SequenceNo < pt2.SequenceNo ORDER BY pt1.TrainID , pt1.SequenceNo;
                          """)).rows.toList();

                              var bookings = (await dbModel.conn.execute("""
SELECT *
FROM booking NATURAL JOIN listed_booking
WHERE
Date = '$selectedYear-$selectedMonth-$selectedDay'
""")).rows.toList();

                              cardsData = searchResult.map((ResultSetRow row) {
                                return TrainCardData(
                                  trainID: int.parse(row.colByName("TrainID")!),
                                  nameEN: row.colByName("NameEN")!,
                                  nameAR: row.colByName("NameAR")!,
                                  source: source,
                                  destination: destination,
                                  date: "$selectedYear-$selectedMonth-$selectedDay",
                                  sTime: int.parse(row.colByName("S_Time")!),
                                  fTime: int.parse(row.colByName("F_Time")!),
                                  businessCapacity: int.parse(row.colByName("BusinessCapacity")!),
                                  economyCapacity: int.parse(row.colByName("EconomyCapacity")!),
                                  bookedBusiness: bookings.where((booking) => booking.colByName("On_ID") == row.colByName("TrainID") && booking.colByName("Coach") == "Business").length,
                                  bookedEconomy: bookings.where((booking) => booking.colByName("On_ID") == row.colByName("TrainID") && booking.colByName("Coach") == "Economy").length,
                                );
                              }).toList();

                              setState(() {});
                            },
                            child: const Text("SEARCH", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  (cardsData == []
                      ? (const SizedBox.shrink())
                      : Expanded(
                          child: (ListView(
                            children: cardsData.map((TrainCardData trainCardData) {
                              return (Column(children: [
                                TrainCard(trainCardData: trainCardData),
                                const SizedBox(height: 10),
                              ]));
                            }).toList(),
                          )),
                        )),
                ],
              )));
  }
}
