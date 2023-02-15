import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/widgets/cart_badge.dart';

import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx_, products, Widget? _) {
              return IconButton(
                onPressed: products.toggleFavourite,
                icon: products.isFavourite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addCartItem(product.id, product.title, product.price);
            },
            icon: cart.items.containsKey(product.id)
                ? CartBadge(
                    value: cart.items[product.id]!.quantity.toString(),
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: null,
                    ),
                  )
                : const Icon(Icons.shopping_cart_outlined),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
