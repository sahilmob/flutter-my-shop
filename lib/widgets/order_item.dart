import "package:flutter/material.dart";
import "package:intl/intl.dart";

import 'package:my_shop/providers/orders.dart' as orderProvider;

class OrderItem extends StatelessWidget {
  final orderProvider.OrderItem order;

  const OrderItem({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$${order.amout}"),
            subtitle: Text(
              DateFormat("dd/MM/yyyy hh:mm").format(order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
