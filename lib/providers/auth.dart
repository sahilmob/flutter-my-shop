import "dart:async";

import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

import 'package:my_shop/mixins/json_helpers.dart';
import 'package:my_shop/models/http_exception.dart';

class Auth with ChangeNotifier, JsonHelpers {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
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
      authLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = encode(
        {
          "token": _token,
          "userId": _userId,
          "expiryDate": _expiryDate.toIso8601String(),
        },
      );
      prefs.setString("userData", userData);
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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData =
        decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    if (DateTime.now().isAfter(expiryDate)) {
      return false;
    }

    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    authLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void authLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
