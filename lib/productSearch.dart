import 'package:cfl_app/search_productdb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DataClasses/appUser.dart';

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
      appBar: AppBar(
        title: Text('Search Products'),
        automaticallyImplyLeading: true,
      ),
      body: Builder(
      builder: (BuildContext context){
        return SearchProductDB(currentDate: DateTime.now(),);
    }
      )
    );
  }
}
