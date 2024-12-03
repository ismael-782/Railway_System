import "package:go_router/go_router.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/tickets.dart";
import "package:railway_system/screens/passenger/account.dart";
import "package:railway_system/screens/passenger/search.dart";

const pages = [PassengerSearch(), PassengerTickets(), PassengerAccount()];

class PassengerIndex extends StatefulWidget {
  const PassengerIndex({super.key});

  @override
  State<PassengerIndex> createState() => _PassengerIndexState();
}

class _PassengerIndexState extends State<PassengerIndex> {
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
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_sharp),
              label: "My Tickets",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account",
            ),
          ],
        ));
  }
}
