import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/search.dart";
import "package:railway_system/screens/landing_page.dart";
import "package:railway_system/screens/staff/index.dart";
import "package:railway_system/models/user.dart";
import "package:railway_system/models/db.dart";

Future main() async {
  await dotenv.load(fileName: ".env");
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
          home: Consumer<UserModel>(builder: (context, user, _) {
            return Consumer<DBModel>(
              builder: (context, db, _) {
                if (!db.isConnected) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue[300],
                      ),
                    ),
                  );
                }

                if (user.isAuthenticated()) {
                  if (user.role() == "Passenger") {
                    Future.microtask(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PassengerSearch(),
                        ),
                      );
                    });
                  } else {
                    Future.microtask(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StaffIndex(),
                        ),
                      );
                    });
                  }

                  return const CircularProgressIndicator();
                } else {
                  return const LandingPage();
                }
              },
            );
          })),
    );
  }
}
