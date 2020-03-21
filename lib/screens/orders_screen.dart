import "package:flutter/material.dart";
import 'package:my_shop/providers/orders.dart' show Orders;
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text("An error occurred!"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, _cchild) {
                  final orders = orderData.orders;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (ctx, i) => OrderItem(
                      order: orders[i],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
