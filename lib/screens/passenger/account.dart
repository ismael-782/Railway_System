import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

class PassengerAccount extends StatefulWidget {
  const PassengerAccount({super.key});

  @override
  State<PassengerAccount> createState() => _PassengerAccountState();
}

class _PassengerAccountState extends State<PassengerAccount> {
  String milesTravelled = "";

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  void getDataFromDB() async {
    var userModel = context.read<UserModel>();
    var dbModel = context.read<DBModel>();

    var query = await dbModel.conn.execute("SELECT * FROM passenger WHERE ID = ${userModel.id()}");
    milesTravelled = query.rows.toList().map((row) => row.colByName("MilesTravelled")!).first;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();

    return (milesTravelled == ""
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.blue[300],
          ))
        : Center(
            child: Column(
                // write name of the user and a logout button
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.account_box, size: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Name:", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      Text(userModel.id()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Miles Travelled:", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      Text(milesTravelled),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red[400])),
                    child: const Text("LOGOUT", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      userModel.logout();
                    },
                  )
                ]),
          ));
  }
}
