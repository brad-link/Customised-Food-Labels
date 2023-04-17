import 'package:cfl_app/appUser.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/productCard.dart';
import 'package:cfl_app/productCardClick.dart';
import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:cfl_app/storedProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/nutritionGoals.dart';

class DailyProducts extends StatefulWidget {
  final DateTime currentDate;
  const DailyProducts({Key? key, required this.currentDate}) : super(key: key);

  @override
  State<DailyProducts> createState() => _DailyProductsState();
}

class _DailyProductsState extends State<DailyProducts> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return StreamBuilder<List<Product>>(
        stream: DatabaseService(uid: user?.uid).getDailyProducts(widget.currentDate),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Product> products = snapshot.data!;
          print(products);

          return Container(
            child: SizedBox(
              height: 200,
            child: ListView.builder(
            itemCount: products.length,
              itemBuilder: (context, index){
                return
                  //GestureDetector(
                    //onTap: () async {
                     // print(products[index].productName);
                      //child:
                      ProductCardClick(product: products[index],
                        date: widget.currentDate,
                        viewButton: () {}, removeButton: () {},);
                   // }
               // );
              }),
          ),
          );
        });
  }
}
