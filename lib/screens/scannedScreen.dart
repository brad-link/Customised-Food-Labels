import 'dart:convert';

import 'package:cfl_app/components/customCheckBox.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/valueCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../TrafficValues.dart';
import '../appUser.dart';
/*
class ScannedScreen extends StatefulWidget {
  final String scanBarcode;
  const ScannedScreen({Key? key, required this.scanBarcode}) : super(key: key);

  @override
  State<ScannedScreen> createState() => _ScannedScreenState();
}

class _ScannedScreenState extends State<ScannedScreen> {
  bool servingChecked = true;
  bool gramsChecked = false;
  String? checked;
  @override
  Widget build(BuildContext context) {
    AppUser? user = Provider.of<AppUser?>(context, listen: false);
    print(widget.scanBarcode);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nutrition Information'),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
        ),
        body: Builder(builder: (BuildContext context) {
          print(widget.scanBarcode);
          return Container(
            alignment: Alignment.center,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                FutureBuilder<Product>(
                    future: getProduct(widget.scanBarcode),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Product? product = snapshot?.data;
                        print(product?.fat_100g);
                        print(product?.serving_quantity);
                        return Container(
                          alignment: Alignment.center,
                          child: Flex(
                            direction: Axis.vertical,
                            children: <Widget>[
                              Text(product!.productName),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text('per 100g'),
                                      value: '100g',
                                      groupValue: checked,
                                      onChanged: (String? value) {
                                        setState(() {
                                          checked = value;
                                        });
                                      },
                                    ),
                                  ),
                                  if (product?.serving_quantity != null)
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text('per serving'),
                                      value: 'serve',
                                      groupValue: checked,
                                      onChanged: (String? value) {
                                        setState(() {
                                          checked = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                             /* Row(
                                children: [
                                  Checkbox(
                                    //title: const Text('per 100g'),
                                    value: gramsChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        gramsChecked = value!;
                                        if (gramsChecked) {
                                          servingChecked = false;
                                        }
                                      });
                                    },
                                  ),
                                  const Text('per 100g'),
                                  if (product?.serving_quantity != null)
                                    Checkbox(
                                        //title: const Text('per serving'),
                                        value: servingChecked,
                                        onChanged: (value) {
                                          servingChecked = value!;
                                          if(servingChecked){
                                            gramsChecked = false;
                                          }
                                        }),
                                  if (product?.serving_quantity != null)
                                    const Text('per serving'),
                                ],
                              ),*/
                              if (checked == '100g')
                                FutureBuilder<TrafficValues?>(
                                    future: DatabaseService(uid: user?.uid)
                                        .getMTL(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        TrafficValues? mtlValues =
                                            snapshot?.data;
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: 4,
                                            itemBuilder: (context, index) {
                                              num? serving;
                                              String? category;
                                              num? size;
                                              num? greenValue;
                                              num? amberValue;
                                              num? intake;
                                              switch (index) {
                                                case 0:
                                                  {
                                                    serving = 100;
                                                    category = 'Fat';
                                                    size = product?.fat_100g;
                                                    greenValue =
                                                        mtlValues?.fatGreen;
                                                    amberValue =
                                                        mtlValues?.fatAmber;
                                                    intake = 70;
                                                    break;
                                                  }
                                                case 1:
                                                  {
                                                    serving = 100;
                                                    category = 'Saturates';
                                                    size = product?.sat_fat100g;
                                                    greenValue =
                                                        mtlValues?.satFatGreen;
                                                    amberValue =
                                                        mtlValues?.satFatAmber;
                                                    intake = 20;
                                                    break;
                                                  }
                                                case 2:
                                                  {
                                                    serving = 100;
                                                    category = 'Sugars';
                                                    size = product?.sugar_100g;
                                                    greenValue =
                                                        mtlValues?.sugarGreen;
                                                    amberValue =
                                                        mtlValues?.sugarAmber;
                                                    intake = 90;
                                                    break;
                                                  }
                                                case 3:
                                                  {
                                                    serving = 100;
                                                    category = 'Salt';
                                                    size = product?.salt_100g;
                                                    greenValue =
                                                        mtlValues?.saltGreen;
                                                    amberValue =
                                                        mtlValues?.saltAmber;
                                                    intake = 70;
                                                    break;
                                                  }
                                              }
                                              return ValueCard(
                                                serving: serving,
                                                category: category,
                                                size: size,
                                                greenValue: greenValue,
                                                amberValue: amberValue,
                                                intake: intake,
                                              );
                                            });
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    }),
                              if (checked == 'serve')
                                FutureBuilder<TrafficValues?>(
                                    future: DatabaseService(uid: user?.uid)
                                        .getMTL(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        TrafficValues? mtlValues =
                                            snapshot?.data;
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: 4,
                                            itemBuilder: (context, index) {
                                              num? serving;
                                              String? category;
                                              num? size;
                                              num? greenValue;
                                              num? amberValue;
                                              num? intake;
                                              switch (index) {
                                                case 0:
                                                  {
                                                    serving = product
                                                        ?.serving_quantity;
                                                    category = 'Fat';
                                                    size = product?.fat;
                                                    greenValue =
                                                        mtlValues?.fatGreen;
                                                    amberValue =
                                                        mtlValues?.fatAmber;
                                                    intake = 70;
                                                    break;
                                                  }
                                                case 1:
                                                  {
                                                    serving = product
                                                        ?.serving_quantity;
                                                    category = 'Saturates';
                                                    size = product?.sat_fat;
                                                    greenValue =
                                                        mtlValues?.satFatGreen;
                                                    amberValue =
                                                        mtlValues?.satFatAmber;
                                                    intake = 20;
                                                    break;
                                                  }
                                                case 2:
                                                  {
                                                    serving = product
                                                        ?.serving_quantity;
                                                    category = 'Sugars';
                                                    size = product?.sugar;
                                                    greenValue =
                                                        mtlValues?.sugarGreen;
                                                    amberValue =
                                                        mtlValues?.sugarAmber;
                                                    intake = 90;
                                                    break;
                                                  }
                                                case 3:
                                                  {
                                                    serving = product
                                                        ?.serving_quantity;
                                                    category = 'Salt';
                                                    size = product?.salt;
                                                    greenValue =
                                                        mtlValues?.saltGreen;
                                                    amberValue =
                                                        mtlValues?.saltAmber;
                                                    intake = 70;
                                                    break;
                                                  }
                                              }
                                              return ValueCard(
                                                serving: serving,
                                                category: category,
                                                size: size,
                                                greenValue: greenValue,
                                                amberValue: amberValue,
                                                intake: intake,
                                              );
                                            });
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    }),
                              /*TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'number of servings: ',
                                  ),
                                  validator: (value) =>value!.isEmpty ? "enter your weight" : null,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      height = null;
                                    } else {
                                      height = num.tryParse(value);
                                    }
                                  })*/
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Unable to retrieve nutritional information');
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
}*/
