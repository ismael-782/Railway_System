import "package:flutter/material.dart";

import "package:railway_system/screens/staff/tickets.dart";
import "package:railway_system/screens/staff/settings/index.dart";
import "package:railway_system/screens/staff/assign.dart";

const pages = [StaffTickets(), StaffAssign(), StaffAccount()];

class StaffIndex extends StatefulWidget {
  const StaffIndex({super.key});

  @override
  State<StaffIndex> createState() => _StaffIndexState();
}

class _StaffIndexState extends State<StaffIndex> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: pages[selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_sharp),
              label: "Manage Tickets",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.engineering),
              label: "Assign Staff",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account",
            ),
          ],
        ));
  }
}
