import "package:provider/provider.dart";
import "package:flutter/material.dart";
import "package:railway_system/screens/firstPage.dart";
import "package:railway_system/screens/passenger/index.dart";
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
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
          ),
          home: SafeArea(
            child: Consumer<UserModel>(
              builder: (context, user, _) {
                if (user.isAuthenticated()) {
                  return user.role() == "Passenger" ? const PassengerIndex() : const Staff();
                } else {
                  return const FirstPage();
                }
              },
            ),
          )),
    );
  }
}
