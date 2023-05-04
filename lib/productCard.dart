import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfl_app/DataClasses/nutritionGoals.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/DataClasses/product.dart';
import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DataClasses/appUser.dart';

class ProductCard extends StatelessWidget {
  final DateTime date;
  final Product product;
  final VoidCallback viewButton;
  const ProductCard({Key? key, required this.product, required this.date, required this.viewButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    num? portion = product.portion;
    num? numPortions = product.numOfPortions;
    String? image = product.image;
    //print(product.sat_fat100g);
    //print(image);
   /* return GestureDetector(
        onTap: () async{
          viewButton;
         NutritionGoals? goals = await DatabaseService(uid: user?.uid).getNutritionGoals();
      ScannedScreen(product: product, goals: goals,date: date);
    },*/
    child:return Card(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if(image != null)
            Image(
              image: CachedNetworkImageProvider(image),
              width: 75.0,
              height: 75.0,
            ),
            Column(
              children: [
                Text(product.productName!),


                    Text('Portion size: $portion'),
                    Text('Number of portions: $numPortions')


              ],
            )

          ],
        ),
      ],
    ),

    );
  }
}
