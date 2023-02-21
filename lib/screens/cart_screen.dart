import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart' show Cart;
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    // var product = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 20)),
                    const Spacer(),
                    Chip(
                      label: Text(
                        'Rs ${cart.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    const TextButton(
                      onPressed: null,
                      child: Text('Order Now'),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, index) {
                  return CartItem(
                    price: cart.items.values.toList()[index].price,
                    title: cart.items.values.toList()[index].title,
                    quantity: cart.items.values.toList()[index].quantity,
                    productId: cart.items.keys.toList()[index],
                    id: cart.items.values.toList()[index].id,
                  );
                },
              ),
            )
          ],
        ));
  }
}
