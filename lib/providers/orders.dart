import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import 'package:my_shop/mixins/json_helpers.dart';
import 'package:my_shop/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier, JsonHelpers {
  List<OrderItem> _orders = [];
  final authToken;
  final userId;

  Orders(this.authToken, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://flutter-shop-ede23.firebaseio.com/orders/$userId.json?auth=$authToken";
    try {
      final response = await http.get(url);
      final decodedRepsonse = decode(response.body) as Map<String, dynamic>;
      List<OrderItem> orders = [];
      if (decodedRepsonse == null) {
        return;
      }
      decodedRepsonse.forEach(
        (key, order) {
          List<CartItem> productsList = [];
          var orderProducts = order["products"] as List<dynamic>;
          orderProducts.forEach(
            (product) {
              productsList.add(
                CartItem(
                  id: product["id"],
                  title: product["title"],
                  quantity: product["quantity"],
                  price: product["price"],
                ),
              );
            },
          );
          orders.add(
            OrderItem(
              id: order["id"],
              dateTime: DateTime.parse(order["dateTime"]),
              amount: order["amount"],
              products: productsList,
            ),
          );
        },
      );

      _orders = orders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://flutter-shop-ede23.firebaseio.com/orders/$userId.json?auth=$authToken";
    final dateTime = DateTime.now();
    final encodedProducts =
        cartProducts.map((product) => product.toJson()).toList();
    try {
      final response = await http.post(
        url,
        body: encode(
          {
            "amount": total,
            "dateTime": dateTime.toIso8601String(),
            "products": encodedProducts,
          },
        ),
      );
      final order = OrderItem(
        id: decode(response.body)["name"],
        amount: total,
        dateTime: dateTime,
        products: cartProducts,
      );
      _orders.insert(
        0,
        order,
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
