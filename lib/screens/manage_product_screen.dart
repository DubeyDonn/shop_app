import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_add_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/manage_product_item.dart';

import '../provider/products_provider.dart';

class ManageProductScreen extends StatefulWidget {
  static const routeName = '/manage-product';
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProductScreen> {
  @override
  Widget build(BuildContext context) {
    var product = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Manage Product'),
        ),
        body: ListView.builder(
          itemCount: product.length,
          itemBuilder: (context, index) {
            return ManageProductItem(
              image: product[index].imageUrl,
              title: product[index].title,
              price: product[index].price,
              productId: product[index].id,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditAddProductScreen.routeName);
          },
          child: const Icon(Icons.add),
        ));
  }
}
