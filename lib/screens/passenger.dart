import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "../models/user.dart";

class Passenger extends StatelessWidget {
  const Passenger({super.key});

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();

    return Scaffold(
      body: Center(
        child: Column(children: [
          Text("Hi Passenger ${userModel.id()}"),
          ElevatedButton(
            child: const Text("LOGOUT"),
            onPressed: () {
              userModel.logout();
            },
          ),
        ]),
      ),
    );
  }
}
