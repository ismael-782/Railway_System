import "package:shared_preferences/shared_preferences.dart";
import "package:flutter/foundation.dart";

class UserModel extends ChangeNotifier {
  late bool _isAuthenticated = false;
  isAuthenticated() => _isAuthenticated;

  late String _id;
  id() => _id;

  late String _name;
  name() => _name;

  late String _role;
  role() => _role;

  UserModel() {
    initialize();
  }

  Future<void> initialize() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? prefId = preferences.getString("id");
    String? prefName = preferences.getString("name");
    String? prefRole = preferences.getString("role");

    if (prefId != null && prefName != null && prefRole != null) {
      authenticate(prefId, prefName, prefRole);
    }
  }

  void authenticate(String id, String name, String role) {
    _isAuthenticated = true;
    _id = id;
    _name = name;
    _role = role;

    notifyListeners();
  }

  void logout() async {
    _isAuthenticated = false;
    _id = "";
    _name = "";
    _role = "";

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("id");
    await preferences.remove("name");
    await preferences.remove("role");

    notifyListeners();
  }
}
