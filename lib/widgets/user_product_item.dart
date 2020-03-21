import 'package:flutter/material.dart';
import 'package:my_shop/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteHandler;

  const UserProductItem(
      {Key key, this.id, this.title, this.imageUrl, this.deleteHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If we wnt to use scaffold in a futetue, we have to cache it.
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductSecreen.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await deleteHandler(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text("Deleting failed!"),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
