import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/models/user.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 200,
            leading: Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  // Handle back button action
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
                          onTap: () {},
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
                        onTap: () {},
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
                        onTap: () {},
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