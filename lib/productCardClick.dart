import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:cfl_app/storedProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appUser.dart';
import 'components/nutritionGoals.dart';
import 'database.dart';

class ProductCardClick extends StatelessWidget {
  final DateTime date;
  final Product product;
  final VoidCallback viewButton;
  const ProductCardClick({Key? key, required this.product, required this.date, required this.viewButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    num? portion = product.portion;
    num? numPortions = product.numOfPortions;
    String? image = product.image;
    return Card(
      child: InkWell(
        onTap: () async {
          //print(product.productName);
          viewButton;
          NutritionGoals? goals = await DatabaseService(uid: user?.uid)
              .getNutritionGoals();
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ScannedScreen(product: product, goals: goals, date: date)));
        },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Portion size: $portion'),
                      Text('Number of portions: $numPortions')
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
      ),
    );
  }
}