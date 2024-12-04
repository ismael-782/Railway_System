import 'package:flutter/material.dart';
import "package:railway_system/screens/login.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
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
                  "assets/imegas/high-speed-train.png",
                  height: 150,
                  width: 180,
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
                      "Create a Username",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 10,
                ),
                // Email TextField
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create a Password",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 10),

                // Password TextField
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Create a password",
                    hintText: "must be 8 characters",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm the Password",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),

                // Confirm Password TextField
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm password",
                    hintText: "repeat password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
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
                  onPressed: () {
                    //TODO
                    // Implement your sign-up functionality here
                    // also this will lead to the log in page so that the user will log in again after creating the account
                    // also chech if the checkbox is pressed or not
                    // if any of the fields is not correct then display a message of the error
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
                          MaterialPageRoute(
                              builder: (context) => const Login()),
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
