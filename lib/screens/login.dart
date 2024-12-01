import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "../models/user.dart";
import "../models/db.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();
    var dbModel = context.watch<DBModel>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text("Railway System", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                labelStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                labelStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
              onPressed: () async {
                var staffResult = await dbModel.conn.execute("SELECT * FROM user NATURAL JOIN staff WHERE ID = '$username' AND Password = '$password'");
                var passengerResult = await dbModel.conn.execute("SELECT * FROM user NATURAL JOIN passenger WHERE ID = '$username' AND Password = '$password'");

                if (staffResult.numOfRows > 0) {
                  userModel.authenticate(username, "Staff");
                } else if (passengerResult.numOfRows > 0) {
                  userModel.authenticate(username, "Passenger");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect username/password.")));
                }
              },
              child: const Text("LOGIN", style: TextStyle(color: Colors.white)),
            ),
          ]),
        ),
      ),
    );
  }
}
