import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import 'package:my_shop/mixins/json_helpers.dart';

class Auth with ChangeNotifier, JsonHelpers {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyASqz26nzmVdRPVEwf1vQ4BswO4iNqMC9Y";
    final response = await http.post(
      url,
      body: encode(
        {"email": email, "password": password, "returnSecureToken": true},
      ),
    );
    print(decode(response.body));
  }
}
