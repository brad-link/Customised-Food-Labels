import 'package:cfl_app/search_productdb.dart';
import 'package:cfl_app/search_user_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabbedSearch extends StatefulWidget {
  final DateTime currentDate;
  const TabbedSearch({Key? key, required this.currentDate}) : super(key: key);

  @override
  State<TabbedSearch> createState() => _TabbedSearchState();
}

class _TabbedSearchState extends State<TabbedSearch> {

  @override

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Search Products'),
            bottom: const TabBar(
                tabs: [
                  Tab(text: 'Your saved products'),
                  Tab(text: 'products'),
                ]),
          ),
          body: TabBarView(
            children: [
              SearchUserProducts(currentDate: widget.currentDate),
              SearchProductDB( currentDate: widget.currentDate)
            ],
          ),
        ));
  }
}
