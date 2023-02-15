import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context).items;
    var product = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView(
        children: const [
         // ListTile(title: cart[product.id].id),
        ],
      ),
    );
  }
}
