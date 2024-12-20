import "package:flutter/material.dart";

import "package:railway_system/screens/signup.dart";
import "package:railway_system/screens/login.dart";

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(149, 240, 241, 241),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon or Image
                  Image.asset(
                    "assets/images/high-speed-train.png", // Your image path
                    width: 221, // Adjust the size as needed
                    height: 201,
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "Saudi Railway",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  const Text(
                    "Welcome to Railway App\nSign in to reserve your next amazing trip with us!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 36, 36, 36),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
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
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Or Section
                  const Text(
                    "Or try one of these methods",
                    style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 36, 36, 36)),
                  ),
                  const SizedBox(height: 20),

                  // Apple Button (Non-pressable)
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/Apple.png",
                          height: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Center(
                          child: Text(
                            "Continue with Apple",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Google Button (Non-pressable)
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/Google.png",
                          height: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Center(
                          child: Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Footer Section
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color.fromARGB(255, 36, 36, 36))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "No way! You are not new?",
                          style: TextStyle(color: Color.fromARGB(255, 36, 36, 36)),
                        ),
                      ),
                      Expanded(child: Divider(color: Color.fromARGB(255, 36, 36, 36))),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Login Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Color.fromARGB(255, 36, 36, 36)),
                      ),
                      GestureDetector(
                        onTap: () {
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
      ),
    );
  }
}
