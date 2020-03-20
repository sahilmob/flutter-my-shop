import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';

class EditProductSecreen extends StatefulWidget {
  static const routeName = "/edit_product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductSecreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      if (!_imageURLController.text.startsWith("http") &&
          !_imageURLController.text.startsWith("https")) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    Products products = Provider.of<Products>(
      context,
      listen: false,
    );
    products.addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a title.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please enter a number greater than zero.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a description.";
                  }
                  if (value.length < 10) {
                    return "Description must be at least 10 characters.";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageURLController.text.isEmpty
                        ? Text("Enter a URL")
                        : FittedBox(
                            child: Image.network(
                              _imageURLController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Image URL",
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageURLController,
                      focusNode: _imageFocusNode,
                      onFieldSubmitted: (_value) => _saveForm(),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter an image URL.";
                        }
                        if (!value.startsWith("http") ||
                            !value.startsWith("https")) {
                          return "Please enter a valid URL.";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
