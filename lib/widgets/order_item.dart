import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/orders.dart' as ord;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../provider/orders.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  final Function()? onOrderCancelled;

  const OrderItem(
      {required this.order, required this.onOrderCancelled, super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  // Function to show a confirmation dialog
  void _showCancelOrderConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx)
                  .pop(false); // Close the dialog without canceling
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx)
                  .pop(true); // Close the dialog and confirm canceling
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        // User confirmed canceling the order
        Provider.of<Orders>(context, listen: false)
            .deleteOrder(widget.order.id);
        widget.onOrderCancelled?.call(); // Call the callback function
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Total: Rs ${widget.order.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: _expanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _expanded
                  ? min(widget.order.products.length * 80.0 + 250, 350)
                  : 0,
              curve: Curves.easeIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.order.paymentMethod,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Shipping Address:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.order.shippingInfo.fullName}, ${widget.order.shippingInfo.address}, ${widget.order.shippingInfo.city}, ${widget.order.shippingInfo.mobileNumber}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ordered Products:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.order.products.length,
                      itemBuilder: (ctx, index) {
                        final product = widget.order.products[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${product.quantity}x   Rs ${product.price}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    //A Button to delete the order
                    TextButton(
                      onPressed: () {
                        _showCancelOrderConfirmationDialog(); // Call the callback function
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: const Text('Cancel Order'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
