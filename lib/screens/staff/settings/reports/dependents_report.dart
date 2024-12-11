import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

class StaffDependentsReport extends StatefulWidget {
  const StaffDependentsReport({super.key});

  @override
  State<StaffDependentsReport> createState() => _StaffDependentsReportState();
}

class _StaffDependentsReportState extends State<StaffDependentsReport> {
  List<int> trainIDs = [];
  int selectedTrainID = 1;
  DateTime? selectedDate;

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();

    var trainsQuery = await dbModel.conn.execute("SELECT ID FROM train");

    setState(() {
      trainIDs = trainsQuery.rows.map((row) => int.parse(row.colByName("ID")!)).toList();
      trainIDs.sort((a, b) => a.compareTo(b));
    });
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.read<UserModel>();

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
              "Dependents Report",
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
              child: Row(
                children: [
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
                  const SizedBox(width: 5),
                  DropdownButton<int>(
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
                      });
                    },
                  )
                ],
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
                  children: trainIDs.map((int trainId) {
                    return const Column(
                      children: [
                        //LoadFactorCard(trainCardData: trainCardData, clickable: false),
                        SizedBox(height: 15),
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
