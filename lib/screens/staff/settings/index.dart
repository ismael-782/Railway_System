import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

class StaffAccount extends StatefulWidget {
  const StaffAccount({super.key});

  @override
  State<StaffAccount> createState() => _StaffAccountState();
}

class _StaffAccountState extends State<StaffAccount> {
  String email = "";

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var userModel = context.read<UserModel>();
    var dbModel = context.read<DBModel>();

    var query = await dbModel.conn.execute("SELECT * FROM staff WHERE ID = '${userModel.id()}'");
    email = query.rows.toList().map((row) => row.colByName("Email")!).first;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();

    return (email == ""
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.blue[300],
          ))
        : Scaffold(
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
                    // child: IconButton(
                    //   icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
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
                                title: const Text("Current Active Trains Report"),
                                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                                onTap: () {
                                  //TrainStationReportCard(trainCardData: );
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
                              title: const Text("Trains Stations Report"),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                              onTap: () {
                                // Navigate to History screen
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => const HistoryTripsPage()),
                                // );
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
                              title: const Text("Waitlisted Loyalty Passengers Report"),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   //MaterialPageRoute(builder: (context) => const CancelledTripsPage()),
                                // );
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
                              title: const Text("Load Factor Report"),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                              onTap: () {
                                //showSnackBar(context, "Our email address is contact@project.sa");
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
                              title: const Text("Dependents Report"),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                              onTap: () {
                                //showSnackBar(context, "Send an account deletion request to contact@project.sa");
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
          ));
  }
}
