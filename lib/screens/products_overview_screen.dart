import 'package:flutter/material.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../data/dummy_products.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
      ),
      body: GridView.builder( // GridView.builder is a better choice than GridView.count
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (context, index) {
          return ProductItem(
            imageUrl: products[index].imageUrl,
            id: products[index].id,
            title: products[index].title,
          );
        },
        itemCount: products.length,
      ),
    );
  }
}
