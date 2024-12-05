import "package:flutter/material.dart";

class StaffAssign extends StatefulWidget {
  const StaffAssign({super.key});

  @override
  State<StaffAssign> createState() => _StaffAssignState();
}

class _StaffAssignState extends State<StaffAssign> {
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  final List<String> months = List.generate(12, (index) => (index + 1).toString());
  final List<String> years = List.generate(2, (index) => (DateTime.now().year + index).toString());

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {}

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("STAFF ASSIGN\nNot implemented yet."));
  }
}
