import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfl_app/DataClasses/product.dart';
import 'package:cfl_app/screens/productView/ScannedScreen.dart';
import 'package:cfl_app/screens/productView/not_custom_scanned.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'DataClasses/appUser.dart';
import 'DataClasses/dietLog.dart';
import 'DataClasses/nutritionGoals.dart';
import 'components/database.dart';
import 'main.dart';

class ClickableProductCard extends StatefulWidget {
  final DateTime date;
  final Product product;
  final VoidCallback viewButton;
  final String section;
  final VoidCallback button;
  const ClickableProductCard({Key? key, required this.date, required this.product, required this.viewButton, required this.section, required this.button}) : super(key: key);

  @override
  State<ClickableProductCard> createState() => _ClickableProductCardState();
}

class _ClickableProductCardState extends State<ClickableProductCard> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    Product product = widget.product;
    num? portion = product.portion;
    num? numPortions = product.numOfPortions;
    String? measurement = product.servingType;
    String? image = product.image;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () async {
          widget.viewButton;
          if(user != null) {
            NutritionGoals? goals =
            await DatabaseService(uid: user.uid).getNutritionGoals();
            if(!mounted) return;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ScannedScreen(
                            product: product, goals: goals, date: widget.date)));
          } else{
            if(!mounted) return;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NotLoggedInScan(product: product)));

          }
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
                if(image == null)
                  const Image(image: AssetImage('assets/images/no-image.png'),
                    height: 75,
                    width: 75,),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.productName!,
                        style: const TextStyle(color: myColor),),
                      Text('Portion size: $portion$measurement',
                        style: const TextStyle(color: myColor),),
                      Text('Number of portions: $numPortions',
                        style: const TextStyle(color: myColor),)
                    ],
                  ),
                ),
                if(widget.section == 'search' && user != null)
                  IconButton(
                    icon:const Icon(Icons.add),
                    color: Colors.green,
                    onPressed: () async{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.productName} added'),
                            duration: const Duration(seconds: 1),)
                      );
                      product.setDateTime(DateTime.now(), DateFormat('dd/MM/yyyy').format(widget.date));
                      CrossAxisAlignment.end;
                      widget.button;
                      product.setServingMacros(product);
                      await DatabaseService(uid: user.uid).updateLog(DietLog.fromProduct(product));
                      await DatabaseService(uid: user.uid).addProduct(product);
                    },
                  ),
                if(widget.section == 'daily' && user != null)
                  IconButton(
                    icon:const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () async{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.productName} removed '),
                            duration: const Duration(seconds: 1),)
                      );
                      CrossAxisAlignment.end;
                      widget.button;
                      product.setServingMacros(product);
                      await DatabaseService(uid: user.uid).removeProductFromDay(product, widget.date);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
