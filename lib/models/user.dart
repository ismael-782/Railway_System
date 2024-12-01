import "package:flutter/foundation.dart";

class UserModel extends ChangeNotifier {
  late bool _isAuthenticated = false;
  isAuthenticated() => _isAuthenticated;

  late String _id;
  id() => _id;

  late String _role;
  role() => _role;

  void authenticate(String id, String role) {
    _isAuthenticated = true;
    _id = id;
    _role = role;

    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _id = "";
    _role = "";

    notifyListeners();
  }
}
