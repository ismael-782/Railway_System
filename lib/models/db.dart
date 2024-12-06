import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:mysql_client/mysql_client.dart";
import "package:flutter/foundation.dart";

class DBModel extends ChangeNotifier {
  late MySQLConnection conn;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  DBModel() {
    initialize();
  }

  Future<void> initialize() async {
    print("Connecting to database...");

    conn = await MySQLConnection.createConnection(
      host: dotenv.env["DB_HOST"]!,
      port: int.parse(dotenv.env["DB_PORT"]!),
      userName: dotenv.env["DB_USER"]!,
      password: dotenv.env["DB_PASS"]!,
      databaseName: dotenv.env["DB_NAME"]!,
    );

    await conn.connect();

    _isConnected = true;
    notifyListeners();

    print("Connected to database!");
  }

  MySQLConnection connection() => conn;
}
