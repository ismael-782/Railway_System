import "package:provider/provider.dart";
import "package:flutter/material.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";
import "package:railway_system/utils.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = "0555456241";
  String password = "A_Pass";

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();
    var dbModel = context.watch<DBModel>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              Image.asset(
                "assets/imegas/high-speed-train.png",
                height: 150.0, // Adjust image size as needed
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Hi, Welcome! 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Username",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Your username",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  var staffResult = await dbModel.conn.execute(
                      "SELECT * FROM user NATURAL JOIN staff WHERE ID = '$username' AND Password = '$password' AND Password IS NOT NULL");
                  var passengerResult = await dbModel.conn.execute(
                      "SELECT * FROM user NATURAL JOIN passenger WHERE ID = '$username' AND Password = '$password' AND Password IS NOT NULL");

                  if (staffResult.numOfRows > 0) {
                    userModel.authenticate(username,
                        staffResult.rows.first.colByName("Name")!, "Staff");
                  } else if (passengerResult.numOfRows > 0) {
                    userModel.authenticate(
                        username,
                        passengerResult.rows.first.colByName("Name")!,
                        "Passenger");
                  } else {
                    showSnackBar(
                        context, "Incorrect username and/or password.");
                  }
                },
                child: const Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
