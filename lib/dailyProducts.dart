import 'package:cfl_app/DataClasses/appUser.dart';
import 'package:cfl_app/clickable_product_card.dart';
import 'package:cfl_app/components/database.dart';
import 'package:cfl_app/DataClasses/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
          List<Product> products = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: myColor,
                  borderRadius: BorderRadius.circular(5),),
                height: 34,
               width: 300,
               child: const Center(child: Text('Products Consumed',
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
              return ClickableProductCard(product: products[index],
                      date: widget.currentDate,
                      viewButton: () {}, button: () {}, section: 'daily',);
                 // }
             // );
            }),
          ),
          ],
          );
          } else{
            return const CircularProgressIndicator();
          }
        });
  }
}
