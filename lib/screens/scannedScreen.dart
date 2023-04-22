import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfl_app/components/customCheckBox.dart';
import 'package:cfl_app/components/dietLog.dart';
import 'package:cfl_app/components/nutritionGoals.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/valueCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../TrafficValues.dart';
import '../addProduct.dart';
import '../appUser.dart';
import '../main.dart';

class ScannedScreen extends StatefulWidget {
  final Product product;
  final DateTime date;
  final NutritionGoals? goals;
  const ScannedScreen(
      {Key? key, required this.product, required this.date, this.goals})
      : super(key: key);

  @override
  State<ScannedScreen> createState() => _ScannedScreenState();
}

class _ScannedScreenState extends State<ScannedScreen> {
  final portionController = TextEditingController();
  final portionStreamController = StreamController<num>();
  //final Stream<num?> portionstream = portionStreamController.stream;
  bool servingChecked = true;
  bool gramsChecked = false;
  String? checked;
  num? portion;
  num numPortion = 1;

  @override
  void initState() {
    super.initState();
    portionStreamController.add(numPortion);
    //portionController.text = numPortion.toString();
    //portionController.addListener(_setPortions);
  }

  @override
  void dispose() {
    portionController.dispose();
    portionStreamController.close();
    super.dispose();
  }

  void _setPortions() {
    num input = num.tryParse(portionController.text)!;
    numPortion = input;
    portionStreamController.sink.add(numPortion!);
  }
  String? selectedPortion;

  @override
  Widget build(BuildContext context) {
    AppUser? user = Provider.of<AppUser?>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Nutrition Information'),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: myColor,
        ),
        body: Builder(builder: (BuildContext context) {
          Product product = widget.product;
          String serving = product.serve_size!;
          String? image = product.image;
          NutritionGoals? personalGoals = widget.goals;
          return SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Text(product.productName!),
                      if (image != null)
                        Image(
                          image: CachedNetworkImageProvider(image),
                        ),
                      Row(
                        children:[
                      Expanded(child: const Text('Serving size: '),),
                      Expanded(child: DropdownButtonFormField<String>(
                        value: selectedPortion,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPortion = newValue!;
                            //checked = selectedPortion;
                            //portion = double.parse(selectedPortion!);
                            print(selectedPortion);
                          });
                        },
                        items: <String>[
                          '1g',
                          '100g',
                          //if(product.serving_quantity != null)
                            //'serving($serving)',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ),
                      ],
                      ),
                      /*
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('1g'),
                              value: '1g',
                              groupValue: checked,
                              onChanged: (String? value) {
                                setState(() {
                                  portion = 1;
                                  checked = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('100g'),
                              value: '100g',
                              groupValue: checked,
                              onChanged: (String? value) {
                                setState(() {
                                  portion = 100;
                                  checked = value;
                                });
                              },
                            ),
                          ),
                          if (product?.serving_quantity != null)
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text('serving($serving)'),
                                value: 'serve',
                                groupValue: checked,
                                onChanged: (String? value) {
                                  setState(() {
                                    portion = product?.serving_quantity;
                                    checked = value;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),*/
                      Row(
                        children: [
                      Expanded(child: const Text('Number of servings: '),),
                      Expanded(child: TextField(
                        controller: portionController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            portionStreamController.add(numPortion);
                            print(selectedPortion);
                          } else {
                            portionStreamController.add(num.tryParse(value)!);
                          }
                        },
                      ),
          ),
                      ],
                      ),
                      if (selectedPortion != null)
                        StreamBuilder<num>(
                            stream: portionStreamController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                num? portions = snapshot.data;
                                print(selectedPortion);
                                return StreamBuilder<TrafficValues?>(
                                    stream: DatabaseService(uid: user?.uid)
                                        .getMTLStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        //num? portions = snapshot?.data;
                                        TrafficValues? mtlValues =
                                            snapshot.data;
                                        //TrafficValues? mtlValues =  await DatabaseService(uid: user?.uid).getMTL();
                                        //snapshot?.data;
                                        return Column(children: [
                                          SizedBox(
                                            height: 200,
                                            child:
                                                //Expanded(child:
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: 7,
                                                    itemBuilder:
                                                        (context, index) {
                                                      num? serving;
                                                      String? category;
                                                      num? size;
                                                      num? greenValue;
                                                      num? amberValue;
                                                      num? intake;
                                                      switch (index) {
                                                        case 0:
                                                          {
                                                            //serving = portion;
                                                            category =
                                                                'Calories';
                                                            size = product
                                                                ?.calories_100g;
                                                            greenValue = null;
                                                            amberValue = null;
                                                            intake =
                                                                personalGoals
                                                                    ?.calories;
                                                            break;
                                                          }
                                                        case 1:
                                                          {
                                                            //serving = portion;
                                                            category = 'Fat';
                                                            size = product
                                                                ?.fat_100g;
                                                            greenValue =
                                                                mtlValues
                                                                    ?.fatGreen;
                                                            amberValue =
                                                                mtlValues
                                                                    ?.fatAmber;
                                                            intake =
                                                                personalGoals
                                                                    ?.fat;
                                                            break;
                                                          }
                                                        case 2:
                                                          {
                                                            //serving = 100;
                                                            category =
                                                                'Saturates';
                                                            size = product
                                                                ?.sat_fat100g;
                                                            greenValue = mtlValues
                                                                ?.satFatGreen;
                                                            amberValue = mtlValues
                                                                ?.satFatAmber;
                                                            intake =
                                                                personalGoals
                                                                    ?.saturates;
                                                            break;
                                                          }
                                                        case 3:
                                                          {
                                                            //serving = portion;
                                                            category =
                                                                'Carbohydrates';
                                                            size = product
                                                                ?.carbs_100g;
                                                            greenValue = null;
                                                            amberValue = null;
                                                            intake = personalGoals
                                                                ?.carbohydrates;
                                                            break;
                                                          }
                                                        case 4:
                                                          {
                                                            //serving = 100;
                                                            category = 'Sugars';
                                                            size = product
                                                                ?.sugar_100g;
                                                            greenValue =
                                                                mtlValues
                                                                    ?.sugarGreen;
                                                            amberValue =
                                                                mtlValues
                                                                    ?.sugarAmber;
                                                            intake =
                                                                personalGoals
                                                                    ?.sugars;
                                                            break;
                                                          }
                                                        case 5:
                                                          {
                                                            //serving = portion;
                                                            category =
                                                                'Protein';
                                                            size = product
                                                                ?.protein_100g;
                                                            greenValue = null;
                                                            amberValue = null;
                                                            intake =
                                                                personalGoals
                                                                    ?.protein;
                                                            break;
                                                          }
                                                        case 6:
                                                          {
                                                            //serving = 100;
                                                            category = 'Salt';
                                                            size = product
                                                                ?.salt_100g;
                                                            greenValue =
                                                                mtlValues
                                                                    ?.saltGreen;
                                                            amberValue =
                                                                mtlValues
                                                                    ?.saltAmber;
                                                            intake =
                                                                personalGoals
                                                                    ?.salt;
                                                            break;
                                                          }
                                                      }
                                                      if(selectedPortion == '100g'){
                                                        portion = 100;
                                                      } else if(selectedPortion == 'serving($serving)'){
                                                        portion = product?.serving_quantity;
                                                      } else if(selectedPortion == '1g'){
                                                        portion = 1;
                                                      }
                                                      return ValueCard(
                                                        serving: portion,
                                                        category: category,
                                                        size: size,
                                                        greenValue: greenValue,
                                                        amberValue: amberValue,
                                                        intake: intake,
                                                        multiplier: portions,
                                                      );
                                                    }),
                                            //),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      myColor),
                                              onPressed: () async {
                                                DietLog update = DietLog(
                                                  date: widget.date,
                                                  fat: updateLog(
                                                      product.fat_100g,
                                                      portion,
                                                      portions),
                                                  calories: updateLog(
                                                      product.calories_100g,
                                                      portion,
                                                      portions),
                                                  carbohydrates: updateLog(
                                                      product.carbs_100g,
                                                      portion,
                                                      portions),
                                                  sugars: updateLog(
                                                      product.sugar_100g,
                                                      portion,
                                                      portions),
                                                  salt: updateLog(
                                                      product.salt_100g,
                                                      portion,
                                                      portions),
                                                  saturates: updateLog(
                                                      product.sat_fat100g,
                                                      portion,
                                                      portions),
                                                  protein: updateLog(
                                                      product.protein_100g,
                                                      portion,
                                                      portions),
                                                );
                                                product.setPortionValues(
                                                    portion!, portions!);
                                                String day =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(widget.date);
                                                product.setDateTime(
                                                    DateTime.now(), day);
                                                await DatabaseService(
                                                        uid: user?.uid)
                                                    .addProduct(product);
                                                await DatabaseService()
                                                    .productsList(product);
                                                await DatabaseService(
                                                        uid: user?.uid)
                                                    .updateLog(update);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Add to Diary')),
                                          Padding(padding: EdgeInsets.all(5),
                                            child: TextButton(
                                              child:const Text('incorrect data? update values'),
                                      onPressed: () =>
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddProduct(barcode: product.code!, product: product, currentDate: widget.date,))),
                                            ),)
                                        ]);
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    });
                              } else {
                                return const CircularProgressIndicator();
                              }
                            })
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }

  int updateLog(num? size, num? serving, num? multiplier) {
    int update = 0;
    if (size != null) {
      update = ((size! / 100) * serving! * multiplier!).toInt();
    }
    return update;
  }
}
