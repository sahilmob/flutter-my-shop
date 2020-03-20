import "package:flutter/material.dart";
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static final routeName = "/user_products";

  @override
  Widget build(BuildContext context) {
    final Products products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductSecreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (_context, index) {
            final item = products.items[index];
            return Column(
              children: <Widget>[
                UserProductItem(
                  id: item.id,
                  title: item.title,
                  imageUrl: item.imageUrl,
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
