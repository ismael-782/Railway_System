import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/screens/staff/cards/load_factor_card.dart";

class StaffLoadFactorReport extends StatefulWidget {
  const StaffLoadFactorReport({super.key});

  @override
  State<StaffLoadFactorReport> createState() => _StaffLoadFactorReportState();
}

class _StaffLoadFactorReportState extends State<StaffLoadFactorReport> {
  List<TrainCardData> cardsData = [];

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();
    var now = DateTime.now();

    // Get all train IDs

    var trainsQuery = await dbModel.conn.execute("SELECT ID FROM train");
    List<TrainCardData> tmpCardsData = [];

    for (var row in trainsQuery.rows) {
      var trainID = row.colByName("ID")!;

      var searchResult = (await dbModel.conn.execute("""
    SELECT 
        pt1.TrainID, pt1.Time AS S_Time, pt2.Time AS F_Time, t.NameEN, t.NameAR, t.BusinessCapacity, t.EconomyCapacity, t.StartsAt_Name, t.EndsAt_Name, t.StartsAt_Time
    FROM
        passing_through pt1 JOIN passing_through pt2 ON pt1.TrainID = pt2.TrainID
            JOIN train t ON pt1.TrainID = t.ID
    WHERE
        pt1.TrainID = $trainID AND pt1.StationName = t.StartsAt_Name AND pt2.StationName = t.EndsAt_Name AND pt1.SequenceNo < pt2.SequenceNo 
    ORDER BY pt1.TrainID, pt1.SequenceNo;
  """)).rows.toList();

      var bookings = (await dbModel.conn.execute("""
    SELECT *
    FROM booking NATURAL JOIN listed_booking
    WHERE
    Date = '${now.year}-${now.month}-${now.day}';
  """)).rows.toList();

      var ptRow = searchResult.first;

      tmpCardsData.add(TrainCardData(
        trainID: int.parse(ptRow.colByName("TrainID")!),
        nameEN: ptRow.colByName("NameEN")!,
        nameAR: ptRow.colByName("NameAR")!,
        source: ptRow.colByName("StartsAt_Name")!,
        destination: ptRow.colByName("EndsAt_Name")!,
        date: "${now.year}-${now.month}-${now.day}",
        sTime: int.parse(ptRow.colByName("S_Time")!),
        fTime: int.parse(ptRow.colByName("F_Time")!),
        businessCapacity: int.parse(ptRow.colByName("BusinessCapacity")!),
        economyCapacity: int.parse(ptRow.colByName("EconomyCapacity")!),
        bookedBusiness: bookings.where((booking) => booking.colByName("On_ID") == ptRow.colByName("TrainID") && booking.colByName("Coach") == "Business").length,
        bookedEconomy: bookings.where((booking) => booking.colByName("On_ID") == ptRow.colByName("TrainID") && booking.colByName("Coach") == "Economy").length,
      ));
    }

    //by train ID
    tmpCardsData.sort((a, b) => a.trainID.compareTo(b.trainID));

    setState(() {
      cardsData = tmpCardsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.read<UserModel>();
    var selectedDate;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(210), // Adjust the height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0), // AppBar background color
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0), // Left bottom corner
              bottomRight: Radius.circular(30.0), // Right bottom corner
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color with opacity
                spreadRadius: 5, // Spread of the shadow
                blurRadius: 10, // Blur effect for shadow
                offset: const Offset(0, 4), // Offset for shadow position
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 200,
            leading: Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: Column(
              children: [
                const Icon(
                  color: Colors.blueGrey,
                  Icons.account_circle,
                  size: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome ${userModel.name()}! 👋",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Ensure text color is black or any other contrast color
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Staff ID: ${userModel.id()}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            centerTitle: true, // Center title
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 8, 0, 8),
            child: Text(
              "Load Factor Report",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(30),
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
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
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
              ),
            ),
        
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(30),
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
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: cardsData.map((TrainCardData trainCardData) {
                    return Column(
                      children: [
                        LoadFactorCard(trainCardData: trainCardData, clickable: false),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
