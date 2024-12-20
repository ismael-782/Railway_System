import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/settings/active_trips_report.dart";
import "package:railway_system/screens/passenger/settings/cancelled_trips.dart";
import "package:railway_system/screens/passenger/settings/history_trips.dart";
import "package:railway_system/screens/passenger/settings/coming_trips.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int milesTravelled = -1;

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();
    var userModel = context.read<UserModel>();

    var passengerQuery = await dbModel.conn.execute("SELECT * FROM passenger WHERE ID = '${userModel.id()}'");
    var passengerRow = passengerQuery.rows.first;

    setState(() {
      milesTravelled = int.parse(passengerRow.colByName("MilesTravelled")!);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(240), // Adjust the height of the AppBar
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 230,
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
                  "Passenger ID: ${userModel.id()}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                (milesTravelled == -1
                    ? const SizedBox.shrink()
                    : Container(
                        height: 25,
                        width: 100,
                        decoration: BoxDecoration(
                          color: milesTravelled >= 100000
                              ? Colors.yellow[700] ?? Colors.yellow // Gold
                              : milesTravelled >= 50000
                                  ? Colors.grey[400] ?? Colors.grey // Silver
                                  : milesTravelled >= 10000
                                      ? Colors.green[400] ?? Colors.green // Green
                                      : Colors.red[400] ?? Colors.red, // Default color
                          border: Border.all(
                            color: milesTravelled >= 100000
                                ? Colors.yellow[800] ?? Colors.yellow // Gold border
                                : milesTravelled >= 50000
                                    ? Colors.grey[600] ?? Colors.grey // Silver border
                                    : milesTravelled >= 10000
                                        ? Colors.green[700] ?? Colors.green // Green border
                                        : Colors.red, // Default border
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            milesTravelled >= 100000
                                ? "Gold"
                                : milesTravelled >= 50000
                                    ? "Silver"
                                    : milesTravelled >= 10000
                                        ? "Green"
                                        : "None", // Default text
                            style: const TextStyle(
                              color: Colors.black, // Default text color
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ))
              ],
            ),
            centerTitle: false, // Center title
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(30), // Adjust the radius for a smoother curve
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Profile Section - No need for an empty Column, remove it
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const SizedBox(), // Empty space if you need padding
                    ),
                    // Options Section
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20), // Adjust the radius for a smoother curve
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.directions_transit_outlined,
                            color: Colors.black,
                          ),
                          title: const Text("Coming Trips"),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ComingTripsPage()));
                          },
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // Adjust the radius for a smoother curve
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.history,
                          color: Colors.black,
                        ),
                        title: const Text("History"),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onTap: () {
                          // Navigate to History screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HistoryTripsPage()),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // Adjust the radius for a smoother curve
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.black,
                        ),
                        title: const Text("Cancelled Trips"),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CancelledTripsPage()),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // Adjust the radius for a smoother curve
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.receipt_rounded,
                          color: Colors.black,
                        ),
                        title: const Text("Current Active Trips Report"),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ActiveTripsReport()),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // Adjust the radius for a smoother curve
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        title: const Text("Delete Account"),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onTap: () {
                          showSnackBar(context, "Send an account deletion request to contact@project.sa");
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // Adjust the radius for a smoother curve
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        title: const Text("Logout"),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onTap: () {
                          userModel.logout();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const SizedBox(), // Empty space if you need padding
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
