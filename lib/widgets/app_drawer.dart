import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/screens/manage_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import '../screens/auth_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var userId = auth.userId;
    var token = auth.token;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          const Divider(),
          if (userId.isNotEmpty || token.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ManageProductScreen.routeName);
              },
            ),
          if (userId.isNotEmpty || token.isNotEmpty) const Divider(),
          userId.isEmpty || token.isEmpty
              ? ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Login'),
                  onTap: () {
                    Navigator.of(context).pushNamed(AuthScreen.routeName);
                  },
                )
              : ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ProductsOverviewScreen.routeName);
                    Provider.of<Auth>(context, listen: false).logOut();
                  },
                ),
          // ListTile(
          //   leading: const Icon(Icons.logout),
          //   title: const Text('Logout'),
          //   onTap: () {
          //     Navigator.of(context).pushNamed(AuthScreen.routeName);
          //     Provider.of<Auth>(context, listen: false).logOut();
          //     // showDialog(
          //     //   context: context,
          //     //   builder: (ctx) {
          //     //     return AlertDialog(
          //     //       title: const Text('Logout?'),
          //     //       content: const Text('Are you sure you want to logout?'),
          //     //       actions: [
          //     //         TextButton(
          //     //           onPressed: Navigator.of(context).pop,
          //     //           child: const Text("No"),
          //     //         ),
          //     //         TextButton(
          //     //             onPressed: () {
          //     //               Navigator.of(context).pop();
          //     //               Provider.of<Auth>(context, listen: false).logout();
          //     //             },
          //     //             child: const Text('Yes'))
          //     //       ],
          //     //     );
          //     //   },
          //     // );
          //   },
          // ),
        ],
      ),
    );
  }
}
