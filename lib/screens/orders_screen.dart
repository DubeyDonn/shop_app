import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart' as ord;

import '../provider/orders.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var orders = Provider.of<Orders>(context, listen: false).orders;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders yet!'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ord.OrderItem(
                  order: orders[index],
                );
              },
            ),
    );
  }
}
