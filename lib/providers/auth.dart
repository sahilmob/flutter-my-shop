import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import 'package:my_shop/mixins/json_helpers.dart';
import 'package:my_shop/models/http_exception.dart';

class Auth with ChangeNotifier, JsonHelpers {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

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
      _token = decodedResponse["idToken"];
      _userId = decodedResponse["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            decodedResponse["expiresIn"],
          ),
        ),
      );
      notifyListeners();
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
