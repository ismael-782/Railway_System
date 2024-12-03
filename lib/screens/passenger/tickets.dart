import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

class PassengerTickets extends StatefulWidget {
  const PassengerTickets({super.key});

  @override
  State<PassengerTickets> createState() => _PassengerTicketsState();
}

class _PassengerTicketsState extends State<PassengerTickets> {
  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var dbModel = context.read<DBModel>();

    /*
      We have the base relation booking
      booking seperates into listed_booking and waitlisted_booking
      listed_booking separates into temp_booking and paid_booking
      Also as another child of booking, we have cancelled_booking

      I want to get all bookings in these subcategories and display them
     */

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();
    var dbModel = context.watch<DBModel>();

    return const Center(
      child: Text("TICKETS"),
    );
  }
}
