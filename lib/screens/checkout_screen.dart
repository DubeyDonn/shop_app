import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import '../provider/shipping_info.dart';
import 'add_shipping_address_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var _isLoading = false;
  var _isUnavailable = false;

  List<ShippingInfo> shippingAddresses = [];
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ShippingInfoProvider>(context, listen: false)
          .fetchAndSetShippingInfo()
          .catchError((error) {
        setState(() {
          _isUnavailable = true;
        });
      });

      setState(() {
        shippingAddresses =
            Provider.of<ShippingInfoProvider>(context, listen: false).items;
        _isLoading = false;
      });
    });
    super.initState();
  }

  // Method to build the shipping address section
  Widget buildShippingAddressSection() {
    return Column(
      children: [
        if (shippingAddresses.isNotEmpty)
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: shippingAddresses.length,
                itemBuilder: (ctx, index) {
                  final shippingInfo = shippingAddresses[index];
                  return ListTile(
                    title: Text(shippingInfo.fullName),
                    leading: Radio(
                      value: shippingInfo.id,
                      groupValue:
                          selectedShippingAddressId, // Track the selected address ID
                      onChanged: (value) {
                        setState(() {
                          selectedShippingAddressId = value.toString();
                        });
                      },
                    ),
                    subtitle: Text(
                        '${shippingInfo.address}, ${shippingInfo.city}, ${shippingInfo.mobileNumber}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                AddShippingAddressScreen.routeName,
                                arguments: shippingInfo.id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            // Implement logic to delete the shipping address
                            await Provider.of<ShippingInfoProvider>(context,
                                    listen: false)
                                .deleteShippingInfo(shippingInfo.id)
                                .then((_) {
                              setState(() {
                                // Remove the deleted address from the list
                                shippingAddresses.removeWhere(
                                    (item) => item.id == shippingInfo.id);
                                if (selectedShippingAddressId ==
                                    shippingInfo.id) {
                                  selectedShippingAddressId = '';
                                }
                              });
                            }).catchError((error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Deleting failed. Please try again later.'),
                              ));
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Add a button to add a new shipping address
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddShippingAddressScreen.routeName);
                },
                child: const Text('Add Shipping Address'),
              ),
            ],
          )
        else
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No shipping addresses available.'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AddShippingAddressScreen.routeName);
                  },
                  child: const Text('Add Shipping Address'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  var selectedShippingAddressId = '';

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context, listen: false);

    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var cartProducts = arguments['cart'] as List<CartItem>;
    var cartTotal = arguments['totalAmount'] as double;

    final shippingInfoProvider =
        Provider.of<ShippingInfoProvider>(context, listen: false);
    // print(shippingInfoProvider.items);

    // final shippingAddresses = shippingInfoProvider.items;

    // var selectedShippingAddressId = '';
    // if (shippingAddresses.isNotEmpty) {
    //   selectedShippingAddressId = shippingAddresses[0].id;
    // }

    // print(shippingAddresses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shipping Addresses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_isUnavailable)
                    const Text('Error loading shipping addresses.')
                  else
                    buildShippingAddressSection(), // Use the method to display the addresses
                ],
              ),
            ),
          ),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Display payment methods here, you can use a similar list view builder as for shipping addresses

                  //add cash on delivery option
                  ListTile(
                    title: const Text('Cash on Delivery'),
                    leading: Radio(
                      value: 'cash_on_delivery',
                      groupValue: 'cash_on_delivery',
                      onChanged: (value) {
                        // Implement logic to set the selected payment method
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartProducts.length,
                  itemBuilder: (ctx, index) {
                    final cartProduct = cartProducts[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(cartProduct.title),
                        subtitle: Text(
                          '${cartProduct.quantity}x   Rs ${cartProduct.price}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Text(
                          'Total: Rs ${(cartProduct.quantity * cartProduct.price).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // displau total amount
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs ${cartTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  //place order button on right bottom
                  ElevatedButton(
                onPressed: () async {
                  // Implement logic to place the order
                  await Provider.of<Orders>(context, listen: false)
                      .addOrder(
                    cartProducts,
                    cartTotal,
                    shippingInfoProvider.findById(selectedShippingAddressId),
                    'cash_on_delivery',
                  )
                      .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Placing order failed. Please try again later.'),
                    ));
                  });

                  Provider.of<Cart>(context, listen: false).clear();

                  Navigator.of(context).pop();
                },
                child: const Text('Place Order'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
