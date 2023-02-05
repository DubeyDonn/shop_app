import 'package:flutter/material.dart';

import '../data/dummy_products.dart';

class ProductDetailsScreen extends StatelessWidget {
  // final String title;
  // final String imageUrl;
  // final String id;
  // const ProductDetailsScreen({
  //   required this.id,
  //   required this.imageUrl,
  //   required this.title,
  //   super.key,
  // });
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String; 
    final product = products.firstWhere((element) => element.id == id);

    
    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '\$ 20',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: const Text(
                'This is a description of the product',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ));
  }
}
