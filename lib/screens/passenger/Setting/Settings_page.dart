import "package:flutter/material.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(210), // Adjust the height of the AppBar
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0), // AppBar background color
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30.0), // Left bottom corner
                bottomRight: Radius.circular(30.0), // Right bottom corner
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.3), // Shadow color with opacity
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
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  onPressed: () {
                    // Handle back button action
                  },
                ),
              ),
              title: const Column(
                children: [
                  Icon(
                    color: Colors.blueGrey,
                    Icons.account_circle,
                    size: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Ismael ! 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .black, // Ensure text color is black or any other contrast color
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Passenger ID: 2205465325642",
                    style: TextStyle(
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
                borderRadius: BorderRadius.circular(
                    30), // Adjust the radius for a smoother curve
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Profile Section - No need for an empty Column, remove it
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          const SizedBox(), // Empty space if you need padding
                    ),
                    // Options Section
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the radius for a smoother curve
                        ),
                        child: _buildOptionsSection("My Comming Trips",
                            Icons.directions_transit_outlined, context)),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the radius for a smoother curve
                        ),
                        child: _buildOptionsSection(
                            "History", Icons.history, context)),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius for a smoother curve
                      ),
                      child: _buildOptionsSection(
                          "My Canceled Trips", Icons.cancel_outlined, context),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius for a smoother curve
                      ),
                      child: _buildOptionsSection(
                          "Delete Account", Icons.delete, context),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          const SizedBox(), // Empty space if you need padding
                    ),
                    // Contact Us Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius for a smoother curve
                      ),
                      child: _buildOptionsSection(
                          "Contact us", Icons.contact_support, context),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          const SizedBox(), // Empty space if you need padding
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius for a smoother curve
                      ),
                      child:
                          _buildOptionsSection("Logout", Icons.logout, context),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          const SizedBox(), // Empty space if you need padding
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

Widget _buildOptionsSection(String title, IconData icon, BuildContext context) {
  return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: () {});
}
