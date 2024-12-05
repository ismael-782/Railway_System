import "package:shared_preferences/shared_preferences.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/index.dart";
import "package:railway_system/screens/staff/index.dart";
import "package:railway_system/screens/signup.dart";
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
  bool rememberMe = false;
  bool isPasswordVisible = false;

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
              // Train image at the top
              Image.asset(
                "assets/images/high-speed-train.png", // Corrected image path
                height: 200.0,
                width: 200,
              ),
              const SizedBox(height: 20.0),
              // Greeting message
              const Text(
                "Hi, Welcome! 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),

              // Email Text Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email address",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                decoration: InputDecoration(
                  hintText: "Your email",
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Password Text Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                obscureText: !isPasswordVisible, // Use the state variable
                decoration: InputDecoration(
                  hintText: "Password",
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible; // Toggle visibility
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Checkbox and Forgot Password Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Forgot password logic can be added here
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  var staffResult = await dbModel.conn.execute("SELECT * FROM user NATURAL JOIN staff WHERE ID = '$username' AND Password = '$password' AND Password IS NOT NULL");
                  var passengerResult = await dbModel.conn.execute("SELECT * FROM user NATURAL JOIN passenger WHERE ID = '$username' AND Password = '$password' AND Password IS NOT NULL");

                  final SharedPreferences preferences = await SharedPreferences.getInstance();

                  if (staffResult.numOfRows > 0) {
                    userModel.authenticate(username, staffResult.rows.first.colByName("Name")!, "Staff");
                    if (rememberMe) {
                      preferences.setString("id", username);
                      preferences.setString("name", staffResult.rows.first.colByName("Name")!);
                      preferences.setString("role", "Staff");
                    }

                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StaffIndex()),
                      );
                    });
                  } else if (passengerResult.numOfRows > 0) {
                    userModel.authenticate(username, passengerResult.rows.first.colByName("Name")!, "Passenger");
                    if (rememberMe) {
                      preferences.setString("id", username);
                      preferences.setString("name", passengerResult.rows.first.colByName("Name")!);
                      preferences.setString("role", "Passenger");
                    }

                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PassengerIndex()),
                      );
                    });
                  } else {
                    showSnackBar(context, "Incorrect username and/or password.");
                  }
                },
                child: const Text(
                  "Log in",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Divider with "Or with"
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.black)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Or with"),
                  ),
                  Expanded(child: Divider(color: Colors.black)),
                ],
              ),
              const SizedBox(height: 20),

              // Sign-up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
