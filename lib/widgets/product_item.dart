import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product item = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: item.id,
            );
          },
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (ctx, product, child) => Icon(
                  item.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
            color: Theme.of(context).accentColor,
            onPressed: item.toggleFavorite,
          ),
          backgroundColor: Colors.black87,
          title: Text(
            item.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => cart.addItem(
              item.id,
              item.price,
              item.title,
            ),
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
