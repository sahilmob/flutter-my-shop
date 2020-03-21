import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import 'package:my_shop/mixins/json_helpers.dart';
import 'package:my_shop/models/http_exception.dart';

class Auth with ChangeNotifier, JsonHelpers {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyASqz26nzmVdRPVEwf1vQ4BswO4iNqMC9Y";
    try {
      final response = await http.post(
        url,
        body: encode(
          {"email": email, "password": password, "returnSecureToken": true},
        ),
      );
      final decodedResponse = decode(response.body);
      if (decodedResponse["error"] != null) {
        throw HttpException(decodedResponse["error"]["message"]);
      }
      print(decode(decodedResponse));
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
