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

class ScannedScreen extends StatefulWidget {
  final Product product;
  const ScannedScreen({Key? key, required this.product}) : super(key: key);

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nutrition Information'),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
        ),
        body: Builder(builder: (BuildContext context) {
          Product product = widget.product;
          String serving = product.serve_size!;
          return Container(
            alignment: Alignment.center,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Text(product!.productName),
                      Image.network(product.image),
                      const Text('Serving size: '),
                      Row(
                        children: [
                          /*Expanded(
                            child: DropdownButton<String>(
                                value: checked,
                                items: <DropdownMenuItem<String>>[
                                  DropdownMenuItem(
                                    value: '1g',
                                    child: Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text('per 1g'),
                                        value: '1g',
                                        groupValue: checked,
                                        onChanged: (String? value) {
                                          setState(() {
                                            checked = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '100g',
                                    child: Expanded(
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
                                  ),
                                  if (product?.serving_quantity != null)
                                    DropdownMenuItem(
                                      value: 'serve',
                                      child: Expanded(
                                        child: RadioListTile<String>(
                                          title: Text('per serving ($serving)'),
                                          value: 'serve',
                                          groupValue: checked,
                                          onChanged: (String? value) {
                                            setState(() {
                                              checked = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                                onChanged: (value) {
                                  checked = value!;
                                }),
                          )*/
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('per 1g'),
                              value: '1g',
                              groupValue: checked,
                              onChanged: (String? value) {
                                setState(() {
                                  checked = value;
                                });
                              },
                            ),
                          ),
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
                                        title: Text('per serving ($serving)'),
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
                      if (checked == '100g')
                        FutureBuilder<TrafficValues?>(
                            future: DatabaseService(uid: user?.uid).getMTL(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                TrafficValues? mtlValues = snapshot?.data;
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
                                            greenValue = mtlValues?.fatGreen;
                                            amberValue = mtlValues?.fatAmber;
                                            intake = 70;
                                            break;
                                          }
                                        case 1:
                                          {
                                            serving = 100;
                                            category = 'Saturates';
                                            size = product?.sat_fat100g;
                                            greenValue = mtlValues?.satFatGreen;
                                            amberValue = mtlValues?.satFatAmber;
                                            intake = 20;
                                            break;
                                          }
                                        case 2:
                                          {
                                            serving = 100;
                                            category = 'Sugars';
                                            size = product?.sugar_100g;
                                            greenValue = mtlValues?.sugarGreen;
                                            amberValue = mtlValues?.sugarAmber;
                                            intake = 90;
                                            break;
                                          }
                                        case 3:
                                          {
                                            serving = 100;
                                            category = 'Salt';
                                            size = product?.salt_100g;
                                            greenValue = mtlValues?.saltGreen;
                                            amberValue = mtlValues?.saltAmber;
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
                            future: DatabaseService(uid: user?.uid).getMTL(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                TrafficValues? mtlValues = snapshot?.data;
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
                                            serving = product?.serving_quantity;
                                            category = 'Fat';
                                            size = product?.fat;
                                            greenValue = mtlValues?.fatGreen;
                                            amberValue = mtlValues?.fatAmber;
                                            intake = 70;
                                            break;
                                          }
                                        case 1:
                                          {
                                            serving = product?.serving_quantity;
                                            category = 'Saturates';
                                            size = product?.sat_fat;
                                            greenValue = mtlValues?.satFatGreen;
                                            amberValue = mtlValues?.satFatAmber;
                                            intake = 20;
                                            break;
                                          }
                                        case 2:
                                          {
                                            serving = product?.serving_quantity;
                                            category = 'Sugars';
                                            size = product?.sugar;
                                            greenValue = mtlValues?.sugarGreen;
                                            amberValue = mtlValues?.sugarAmber;
                                            intake = 90;
                                            break;
                                          }
                                        case 3:
                                          {
                                            serving = product?.serving_quantity;
                                            category = 'Salt';
                                            size = product?.salt;
                                            greenValue = mtlValues?.saltGreen;
                                            amberValue = mtlValues?.saltAmber;
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
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
