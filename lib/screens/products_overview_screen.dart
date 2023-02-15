import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/cart_badge.dart';

import '../widgets/products_overview_gridview.dart';

enum FilterGrid {
  favourites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFav = false;
  @override
  Widget build(BuildContext context) {
    var cartItemCount = Provider.of<Cart>(context).itemCount;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: FilterGrid.favourites,
                  child: Text('Only Favourites'),
                ),
                const PopupMenuItem(
                  value: FilterGrid.all,
                  child: Text('All'),
                ),
              ];
            },
            onSelected: (FilterGrid value) {
              setState(() {
                if (value == FilterGrid.favourites) {
                  _showFav = true;
                } else {
                  _showFav = false;
                }
              });
            },
          ),
          Container(
            padding: const EdgeInsets.only(
              right: 8,
              top: 8,
              bottom: 8,
              left: 0,
            ),
            child: Consumer<Cart>(
              builder: (context, value, ch) => CartBadge(
                value: cartItemCount.toString(),
                color: Colors.orange,
                child: ch!,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                // ignore: avoid_returning_null_for_void
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          )
        ],
      ),
      body: BuildProductsOverviewGridview(_showFav),
    );
  }
}
