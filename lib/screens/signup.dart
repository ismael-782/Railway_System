import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:railway_system/models/db.dart";
import "package:railway_system/screens/login.dart";
import "package:railway_system/utils.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String username = "";
  String password = "";
  String name = "";
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    var dbModel = context.watch<DBModel>();

    return Scaffold(
      // this if we want to make a return button at the top left
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Train icon (use your local image asset here)
                Image.asset(
                  "assets/images/high-speed-train.png",
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 20),

                // "Sign up" title
                const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // text above the textfield
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ID",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 10,
                ),
                // Email TextField
                TextField(
                  maxLength: 10,
                  decoration: const InputDecoration(labelText: "Create an account", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), counterText: ""),
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 10),
                // Password TextField
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Create a password",
                    hintText: "must be 8 characters",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 10),
                // Confirm Password TextField
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Create a name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Terms and conditions checkbox
                Row(
                  children: [
                    Checkbox(
                      value: termsAccepted,
                      activeColor: Colors.black,
                      onChanged: (bool? value) {
                        setState(() {
                          termsAccepted = value!;
                        });
                      },
                    ),
                    const Text("I accept the terms and privacy policy")
                  ],
                ),
                const SizedBox(height: 20),

                // Create Account Button
                ElevatedButton(
                  onPressed: () async {
                    if (username.isEmpty || password.isEmpty || name.isEmpty) {
                      return showSnackBar(context, "Please fill all fields.");
                    }

                    if (!termsAccepted) {
                      return showSnackBar(context, "Please accept the terms and privacy policy.");
                    }

                    if (password.length < 8) {
                      return showSnackBar(context, "Password must be at least 8 characters.");
                    }

                    var currentUsers = await dbModel.conn.execute("SELECT * FROM user WHERE ID = '$username'");

                    if (currentUsers.rows.isNotEmpty && currentUsers.rows.first.colByName("Password") != null) {
                      return showSnackBar(context, "Username already exists.");
                    }

                    if (currentUsers.rows.isNotEmpty && currentUsers.rows.first.colByName("Password") == null) {
                      await dbModel.conn.execute("UPDATE user SET Password = '$password', Name = '$name' WHERE ID = '$username'");
                      return showSnackBar(context, "Account created, please login.");
                    }

                    await dbModel.conn.execute("INSERT INTO user (ID, Name, Password) VALUES ('$username', '$name', '$password')");
                    await dbModel.conn.execute("INSERT INTO passenger (ID, MilesTravelled) VALUES ('$username', 0)");

                    showSnackBar(context, "Account created, please login.");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // "Already have an account?" link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
