import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:railway_system/screens/passenger.dart";
import "package:railway_system/screens/login.dart";
import "package:railway_system/screens/staff.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => DBModel()),
      ],
      child: MaterialApp(home: SafeArea(
        child: Consumer<UserModel>(
          builder: (context, user, _) {
            if (user.isAuthenticated()) {
              return user.role() == "Passenger" ? const Passenger() : const Staff();
            } else {
              return const Login();
            }
          },
        ),
      )),
    );
  }
}
