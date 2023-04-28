import 'package:cfl_app/appUser.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/productCard.dart';
import 'package:cfl_app/productCardClick.dart';
import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/nutritionGoals.dart';
import 'main.dart';

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
          if(snapshot.hasData){
          List<Product> products = snapshot.data!;
          print(products);
          return Container(
                //border: Border.all(color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: myColor,
                    borderRadius: BorderRadius.circular(5),),
                  height: 34,
                 width: 300,
                 child: Center(child: Text('Consumed Today',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.bold,
                     fontSize: 20.0,
                   ),),),
                ),
            SizedBox(
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
            ],
            ),
          );
          } else{
            return Container();
          }
        });
  }
}
