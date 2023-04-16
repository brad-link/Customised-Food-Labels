import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfl_app/components/customCheckBox.dart';
import 'package:cfl_app/components/dietLog.dart';
import 'package:cfl_app/components/nutritionGoals.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/storedProduct.dart';
import 'package:cfl_app/valueCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../TrafficValues.dart';
import '../appUser.dart';

class ScannedScreen extends StatefulWidget {
  final Product product;
  final DateTime date;
  final NutritionGoals? goals;
  const ScannedScreen({Key? key, required this.product, required this.date, this.goals}) : super(key: key);

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
          String? image = product.image;
          NutritionGoals? personalGoals = widget.goals;
          return Container(
            alignment: Alignment.center,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Text(product.productName!),
                      if(image != null)
                      Image(
                        image: CachedNetworkImageProvider(image),
                      ),
                      const Text('Serving size: '),
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
                      ),
                      const Text('Number of servings: '),
                      TextField(
                        controller: portionController,
                        keyboardType: TextInputType.number,
                        /*inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],*/
                        //validator: (value) =>value!.isEmpty ? "enter your weight" : null,
                        onChanged: (value) {
                          if(value.isEmpty){
                            portionStreamController.add(numPortion);
                          } else{
                            portionStreamController.add(num.tryParse(value)!);
                          }
                        },
                      ),
                      if (checked != null)
                        StreamBuilder<num>(
                            stream: portionStreamController.stream,
                            builder: (context, snapshot){
                              if (snapshot.hasData) {
                                num? portions = snapshot.data;
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
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              itemCount: 7,
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
                                                      //serving = portion;
                                                      category = 'Calories';
                                                      size = product?.calories_100g;
                                                      greenValue = null;
                                                      amberValue = null;
                                                      intake = personalGoals?.calories;
                                                      break;
                                                    }
                                                  case 1:
                                                    {
                                                      //serving = portion;
                                                      category = 'Fat';
                                                      size = product?.fat_100g;
                                                      greenValue =
                                                          mtlValues?.fatGreen;
                                                      amberValue =
                                                          mtlValues?.fatAmber;
                                                      intake = personalGoals?.fat;
                                                      break;
                                                    }
                                                  case 2:
                                                    {
                                                      //serving = 100;
                                                      category = 'Saturates';
                                                      size =
                                                          product?.sat_fat100g;
                                                      greenValue = mtlValues
                                                          ?.satFatGreen;
                                                      amberValue = mtlValues
                                                          ?.satFatAmber;
                                                      intake = personalGoals?.saturates;
                                                      break;
                                                    }
                                                  case 3:
                                                    {
                                                      //serving = portion;
                                                      category = 'Carbohydrates';
                                                      size = product?.carbs_100g;
                                                      greenValue = null;
                                                      amberValue = null;
                                                      intake = personalGoals?.carbohydrates;
                                                      break;
                                                    }
                                                  case 4:
                                                    {
                                                      //serving = 100;
                                                      category = 'Sugars';
                                                      size =
                                                          product?.sugar_100g;
                                                      greenValue =
                                                          mtlValues?.sugarGreen;
                                                      amberValue =
                                                          mtlValues?.sugarAmber;
                                                      intake = personalGoals?.sugars;
                                                      break;
                                                    }
                                                  case 5:
                                                    {
                                                      //serving = portion;
                                                      category = 'Protein';
                                                      size = product?.protein_100g;
                                                      greenValue = null;
                                                      amberValue = null;
                                                      intake = personalGoals?.protein;
                                                      break;
                                                    }
                                                  case 6:
                                                    {
                                                      //serving = 100;
                                                      category = 'Salt';
                                                      size = product?.salt_100g;
                                                      greenValue =
                                                          mtlValues?.saltGreen;
                                                      amberValue =
                                                          mtlValues?.saltAmber;
                                                      intake = personalGoals?.salt;
                                                      break;
                                                    }
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

                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green
                                            ),
                                              onPressed: () async{
                                              DietLog update = DietLog(
                                                  date: widget.date,
                                              fat: updateLog(product.fat_100g, portion, portions),
                                                calories: updateLog(product.calories_100g, portion, portions),
                                                carbohydrates: updateLog(product.carbs_100g, portion, portions),
                                                sugars: updateLog(product.sugar_100g, portion, portions),
                                                salt: updateLog(product.salt_100g, portion, portions),
                                                saturates: updateLog(product.sat_fat100g, portion, portions),
                                                protein: updateLog(product.protein_100g, portion, portions),
                                              );
                                              product.setPortionValues(portion!, portions!);
                                              String day = DateFormat('dd/MM/yyyy').format(widget.date);
                                              product.setDateTime(DateTime.now(), day);
                                              await DatabaseService(uid: user?.uid).addProduct(product);
                                              await DatabaseService(uid: user?.uid).updateLog(update);
                                              Navigator.pop(context);
                                              }, child: const Text('Add to Diary'))
                                        ]);
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    });
                              } else{
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

  int updateLog(num? size, num? serving, num? multiplier){
    int update = 0;
    if(size != null){
      update = ((size!/100) * serving! * multiplier!).toInt();
    }
    return update;
  }
}
