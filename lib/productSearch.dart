import 'package:cfl_app/components/customAppBar.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

import 'appUser.dart';

class ProductSearch extends StatefulWidget {
  final DateTime currentDate;
  const ProductSearch({Key? key, required this.currentDate}) : super(key: key);

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search Saved Products',
      ),
      body: StreamBuilder<List<Product>>(
        stream: DatabaseService(uid: user?.uid).getSavedProducts(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<Product> savedProducts = snapshot.data!;
            return ListView.builder(
                itemCount: savedProducts.length,
                itemBuilder: (context, index){
                  return ProductCard(product: savedProducts[index], date: widget.currentDate, viewButton: () {  },);
                });
          } else{
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search saved Products',
        onPressed: () async => showSearch<Product?>(
          context: context,
          delegate: SearchPage<Product?>(
            onQueryUpdate: print,
            items: await DatabaseService(uid: user?.uid).getSavedProductsFuture(),
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
            builder: (product) => ProductCard(
              product: product!,
              date: widget.currentDate,
              viewButton: () {  },
            ),
          ),
        ),
        child: const Icon(Icons.search),
      ),
    );
  }
}
