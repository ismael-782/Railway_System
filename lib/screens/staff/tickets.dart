import "package:flutter/material.dart";

class StaffTickets extends StatefulWidget {
  const StaffTickets({super.key});

  @override
  State<StaffTickets> createState() => _StaffTicketsState();
}

class _StaffTicketsState extends State<StaffTickets> {
  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {}

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("STAFF TICKETS\nNot implemented yet."));
  }
}
