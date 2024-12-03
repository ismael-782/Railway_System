import "package:mysql_client/mysql_client.dart";
import "package:flutter/foundation.dart";

class DBModel extends ChangeNotifier {
  late MySQLConnection conn;

  DBModel() {
    initialize();
  }

  Future<void> initialize() async {
    print("Connecting to database...");

    conn = await MySQLConnection.createConnection(
      host: "ics321-mysql-ics321-project.b.aivencloud.com",
      port: 27736,
      userName: "avnadmin",
      password: "AVNS_w9tDlraygvzt3ujJXuw",
      databaseName: "defaultdb",
    );

    await conn.connect();
    print("Connected to database!");
  }

  MySQLConnection connection() => conn;
}
