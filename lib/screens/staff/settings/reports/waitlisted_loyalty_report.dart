import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

class StaffWaitlistedLoyaltyReport extends StatefulWidget {
  const StaffWaitlistedLoyaltyReport({super.key});

  @override
  State<StaffWaitlistedLoyaltyReport> createState() => _StaffWaitlistedLoyaltyReportState();
}

class _StaffWaitlistedLoyaltyReportState extends State<StaffWaitlistedLoyaltyReport> {
  List<int> trainIDs = [];

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();

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
              "Waitlisted Loyalty Passenger Report",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                  cacheExtent: 100000,
                  children: const [SizedBox.shrink()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
