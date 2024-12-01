import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "../models/user.dart";

class Staff extends StatelessWidget {
  const Staff({super.key});

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Hi Staff ${userModel.id()}"),
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
