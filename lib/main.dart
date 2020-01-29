import 'package:flutter/material.dart';
import 'package:my_shop/screens/product_details_screen.dart';
import 'package:my_shop/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: "Lato",
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
      },
    );
  }
}
