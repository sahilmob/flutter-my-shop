import "dart:convert";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import 'package:my_shop/mixins/json_helpers.dart';
import 'package:my_shop/models/http_exception.dart';

class Product with ChangeNotifier, JsonHelpers {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setIsFavoriteValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token) async {
    final url =
        "https://flutter-shop-ede23.firebaseio.com/products/$id.json?auth=$token";
    _setIsFavoriteValue(!isFavorite);
    try {
      final response = await http.patch(
        url,
        body: encode(
          {"isFavorite": isFavorite},
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException("An error occurred");
      }
    } catch (error) {
      _setIsFavoriteValue(!isFavorite);
    }
  }

  String toJson() {
    return json.encode({
      "title": title,
      "description": description,
      "price": price,
      "imageUrl": imageUrl,
      "isFavorite": isFavorite,
    });
  }
}
