import "package:flutter/material.dart";
import 'package:my_shop/providers/orders.dart' show Orders;
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) => OrderItem(
          order: orders[i],
        ),
      ),
    );
  }
}
