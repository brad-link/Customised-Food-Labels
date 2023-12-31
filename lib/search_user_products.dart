import 'package:cfl_app/DataClasses/appUser.dart';
import 'package:cfl_app/clickable_product_card.dart';
import 'package:cfl_app/DataClasses/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

import 'components/database.dart';

class SearchUserProducts extends StatelessWidget {
  final DateTime currentDate;
  const SearchUserProducts({Key? key, required this.currentDate})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<Product> searchProducts;
    final user = Provider.of<AppUser?>(context);
    return Scaffold(
      body: StreamBuilder<List<Product>>(
        stream: DatabaseService(uid: user?.uid).getUsersSavedProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> savedProducts = snapshot.data!;
            searchProducts = snapshot.data!;
            return ListView.builder(
                itemCount: savedProducts.length,
                itemBuilder: (context, index) {
                  return ClickableProductCard(
                    product: savedProducts[index],
                    date: currentDate,
                    section: 'search',
                    button: (){},
                    viewButton: () {},
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search My Products',
        onPressed: () async => showSearch<Product?>(
          context: context,
          delegate: SearchPage<Product?>(
            onQueryUpdate: print,
            items: await DatabaseService(uid: user?.uid).getUsersProductsFuture(),
            searchLabel: 'Search saved products',
            suggestion: const Center(
              child: Text('Filter products by name'),
            ),
            failure: const Center(
              child: Text('Product not found'),
            ),
            filter: (product) => [
              product?.productName,
            ],
            builder: (product) => ClickableProductCard(
              product: product!,
              date: currentDate,
              section: 'search',
              button: (){},
              viewButton: () {},
            ),
          ),
        ),
        child: const Icon(Icons.search),
      ),
    );
  }
}
