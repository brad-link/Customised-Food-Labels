import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appUser.dart';
import 'components/nutritionGoals.dart';
import 'database.dart';

class ProductCardClick extends StatelessWidget {
  final DateTime date;
  final Product product;
  final VoidCallback viewButton;
  final VoidCallback removeButton;
  const ProductCardClick(
      {Key? key,
      required this.product,
      required this.date,
      required this.viewButton,
        required this.removeButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    num? portion = product.portion;
    num? numPortions = product.numOfPortions;
    String? image = product.image;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () async {
          //print(product.productName);
          viewButton;
          NutritionGoals? goals =
              await DatabaseService(uid: user?.uid).getNutritionGoals();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScannedScreen(
                      product: product, goals: goals, date: date)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (image != null)
                  Image(
                    image: CachedNetworkImageProvider(image),
                    width: 75.0,
                    height: 75.0,
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.productName!),
                    Text('Portion size: $portion'),
                    Text('Number of portions: $numPortions')
                  ],
                ),
                ElevatedButton(onPressed: () async{
                  CrossAxisAlignment.end;
                  removeButton;
                  product.setServingMacros(product);
                  await DatabaseService(uid: user?.uid).removeProductFromDay(product, date);
                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                    ),
                    child: const Text('-'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
