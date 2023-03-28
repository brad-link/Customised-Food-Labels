import 'dart:convert';

import 'package:cfl_app/database.dart';
import 'package:cfl_app/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../TrafficValues.dart';
import '../appUser.dart';
import '../main.dart';

class ScannedScreen extends StatefulWidget {
  final String scanBarcode;
  final TrafficValues? mtlValues;
  const ScannedScreen({Key? key, required this.scanBarcode, this.mtlValues})
      : super(key: key);

  @override
  State<ScannedScreen> createState() => _ScannedScreenState();
}

class _ScannedScreenState extends State<ScannedScreen> {
  bool servingChecked = false;
  bool gramsChecked = true;
  @override
  Widget build(BuildContext context) {
    AppUser? user = Provider.of<AppUser?>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nutrition Information'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                FutureBuilder<Product>(
                    future: getProduct(scanBarcode),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Product? product = snapshot?.data;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: gramsChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      gramsChecked = value!;
                                      servingChecked = false;
                                    });
                                  },
                                ),
                                const Text('per 100g'),
                                Checkbox(
                                    value: servingChecked,
                                    onChanged: (value) {
                                      servingChecked = value!;
                                      gramsChecked = false;
                                    }),
                                const Text('per serving'),
                              ],
                            ),
                            if (gramsChecked)
                              FutureBuilder<TrafficValues?>(
                                  future: DatabaseService(uid: user?.uid).getMTL(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      TrafficValues? mtlValues = snapshot?.data;
                                      return ListView.builder(
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            String? category;
                                            num? size;
                                            num? greenValue;
                                            num? amberValue;
                                            num? intake;
                                            switch (index) {
                                              case 0:
                                                {
                                                  category = 'Fat';
                                                  size = product?.fat_100g;
                                                  greenValue = mtlValues?.fatGreen;
                                                  amberValue = mtlValues?.fatAmber;
                                                  intake = 70;
                                                  break;
                                                }
                                              case 1:
                                                {
                                                  category = 'Saturates';
                                                  size = product?.sat_fat100g;
                                                  greenValue = mtlValues?.satFatGreen;
                                                  amberValue = mtlValues?.satFatAmber;
                                                  intake = 20;
                                                  break;
                                                }
                                              case 2:
                                                {
                                                  category = 'Sugars';
                                                  size = product?.sugar_100g;
                                                  greenValue = mtlValues?.sugarGreen;
                                                  amberValue = mtlValues?.sugarAmber;
                                                  intake = 90;
                                                  break;
                                                }
                                              case 3:
                                                {
                                                  category = 'Salt';
                                                  size = product?.salt_100g;
                                                  greenValue = mtlValues?.saltGreen;
                                                  amberValue = mtlValues?.saltAmber;
                                                  intake = 70;
                                                  break;
                                                }
                                            }
                                          });
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  })
                          ],
                        );
                      } else if(snapshot.hasError){
                        return Text('Unable to retrieve nutritional information');
                      }
                      return const CircularProgressIndicator();
                    })
              ],
            ),
          );
        })
        /*body: Column(
        children: [
          Row(
            children: [
              Checkbox(
                  value: gramsChecked,
                  onChanged: (value){
                    setState(() {
                      gramsChecked = value!;
                      servingChecked = false;
                    });
                  },
              ),
              const Text('per 100g'),
              Checkbox(
                  value: servingChecked,
                  onChanged: (value){
                    servingChecked = value!;
                    gramsChecked = false;
                  })
            ],
          )
        ],
      )*/
        );
  }
}

Future<Product> getProduct(scanBarcode) async {
  final url =
      "https://world.openfoodfacts.org/api/v0/product/$scanBarcode.json";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonProduct = jsonDecode(response.body);
    return Product.fromJson(jsonProduct);
  } else {
    throw Exception();
  }
}
