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

    var query = await dbModel.conn.execute("SELECT * FROM staff WHERE ID = ${userModel.id()}");
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
        : Center(
            child: SizedBox(
              width: 250,
              child: Column(
                  // write name of the user and a logout button
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_box, size: 100),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Name:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(userModel.name()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ID:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(userModel.id()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(email),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red[400])),
                      child: const Text("LOGOUT", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        userModel.logout();
                        Navigator.pop(context);
                      },
                    )
                  ]),
            ),
          ));
  }
}
