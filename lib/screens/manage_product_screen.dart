import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_add_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/manage_product_item.dart';

import '../provider/products_provider.dart';

class ManageProductScreen extends StatelessWidget {
  static const routeName = '/manage-product';
  const ManageProductScreen({super.key});

  Future<void> _refreshPage(BuildContext context) async {
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .FetchAndSetProducts();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('No products available.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Manage Product'),
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshPage(context),
          child: ListView.builder(
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditAddProductScreen.routeName);
          },
          child: const Icon(Icons.add),
        ));
  }
}
