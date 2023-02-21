import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import 'screens/product_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return ProductsProvider();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return Orders();
        }),
      ],
      child: MaterialApp(
          title: 'shop App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            colorScheme: const ColorScheme.light().copyWith(
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
            textTheme: ThemeData.light().textTheme.copyWith(
                  titleLarge: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          // home: const ProductsOverviewScreen(),
          routes: {
            ProductDetailsScreen.routeName: (ctx) =>
                const ProductDetailsScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            '/': (context) =>
                const ProductsOverviewScreen(),
          }),
    );
  }
}
