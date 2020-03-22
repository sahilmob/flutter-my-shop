import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:my_shop/mixins/json_helpers.dart';
import 'package:my_shop/models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier, JsonHelpers {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    try {
      final filterString =
          filterByUser ? "&orderBy=\"creatorId\"&equalTo=\"$userId\"" : "";
      var url =
          "https://flutter-shop-ede23.firebaseio.com/products.json?auth=$authToken$filterString";
      final response = await http.get(url);
      final decodedProducts = decode(response.body) as Map<String, dynamic>;
      final List<Product> items = [];
      if (decodedProducts == null) {
        return;
      }
      url =
          "https://flutter-shop-ede23.firebaseio.com/userFavorites/$userId.json?auth=$authToken";
      final favoriteResponse = await http.get(url);
      final favdoriteData = decode(favoriteResponse.body);
      decodedProducts.forEach(
        (key, productData) {
          items.add(
            Product(
              id: key,
              title: productData["title"],
              description: productData["description"],
              price: productData["price"],
              imageUrl: productData["imageUrl"],
              isFavorite:
                  favdoriteData == null ? false : favdoriteData[key] ?? false,
            ),
          );
        },
      );
      _items = items;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future addProduct(Product product) async {
    final url =
        "https://flutter-shop-ede23.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        url,
        body: encode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "creatorId": userId
          },
        ),
      );
      final decodedResponse = decode(response.body);
      // since we have to add and id to the product and all fields are final we hanve to create new product
      final newProduct = Product(
        id: decodedResponse["name"],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product newProduct) async {
    final productIndex =
        _items.indexWhere((product) => product.id == newProduct.id);
    if (productIndex >= 0) {
      try {
        final url =
            "https://flutter-shop-ede23.firebaseio.com/products/${newProduct.id}.json?auth=$authToken";
        await http.patch(
          url,
          body: encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl": newProduct.imageUrl
          }),
        );
        _items[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  void deleteProduct(String productId) async {
    final url =
        "https://flutter-shop-ede23.firebaseio.com/products/$productId.json?auth=$authToken";
    final exisitingProductIndex =
        _items.indexWhere((product) => product.id == productId);
    var exisitingProduct = _items[exisitingProductIndex];
    _items.removeAt(exisitingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(exisitingProductIndex, exisitingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    exisitingProduct = null;
  }
}
