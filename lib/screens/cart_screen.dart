import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart' show Cart;
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/checkout_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../provider/auth.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);

    // var product = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
        drawer: const AppDrawer(),
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
                    CheckoutButton(cart: cart),
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

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var userId = auth.userId;
    var token = auth.token;
    return TextButton(
      onPressed: (widget.cart.items.isEmpty || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              if (token.isEmpty || userId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: const Text('Please log in to continue.'),
                      action: SnackBarAction(
                        label: 'Login',
                        onPressed: () {
                          Navigator.of(context).pushNamed(AuthScreen.routeName);
                        },
                      )),
                );
                setState(() {
                  _isLoading = false;
                });
                return;
              }

              // await Provider.of<Orders>(context, listen: false).addOrder(
              //   widget.cart.items.values.toList(),
              //   widget.cart.totalAmount,
              // );

              // widget.cart.clear();
              //navigate to checkout screen with cart data


              Navigator.of(context).pushNamed(CheckoutScreen.routeName,
                  arguments: {'cart': widget.cart.items.values.toList(),
                  'totalAmount': widget.cart.totalAmount});

              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : widget.cart.items.isEmpty
              ? const Text('Checkout', style: TextStyle(color: Colors.grey))
              : const Text('Checkout', style: TextStyle(color: Colors.green)),
    );
  }
}
