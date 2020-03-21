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

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    print("ordering");
    const url = "https://flutter-shop-ede23.firebaseio.com/orders.json";
    final dateTime = DateTime.now();
    final encodedProducts =
        cartProducts.map((product) => product.toJson()).toList();
    print(encodedProducts);

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
      print(response.statusCode);
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
      print("added");
    } catch (error) {
      print("error");
      print(error);
      throw error;
    }
  }
}
