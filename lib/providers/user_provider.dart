import 'package:flutter/cupertino.dart';
import 'package:instagram_flutter/models/users.dart' as model;
import 'package:instagram_flutter/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();
  model.User get getUser {
    return _user!;
  }

  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
