import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfl_app/DataClasses/TrafficValues.dart';
import 'package:cfl_app/DataClasses/nutritionGoals.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../DataClasses/product.dart';
import '../valueCard.dart';

class NotLoggedInScan extends StatefulWidget {
  final Product product;
  const NotLoggedInScan({Key? key, required this.product}) : super(key: key);

  @override
  State<NotLoggedInScan> createState() => _NotLoggedInScanState();
}

class _NotLoggedInScanState extends State<NotLoggedInScan> {
  bool servingChecked = true;
  bool gramsChecked = false;
  String? checked;
  num? portion;
  num portions = 1;
  String? measurement;
  String? oneGramorMl;
  String? hundredGramOrMl;
  String? selectedPortion = '1g';

  @override
  void initState() {
    super.initState();
    measurement = widget.product.servingType ?? 'g';
    oneGramorMl = '1$measurement';
    hundredGramOrMl = '100$measurement';
    selectedPortion = oneGramorMl;
  }

  @override
  Widget build(BuildContext context) {
    TrafficValues mtlValues = TrafficValues();
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Information'),
        automaticallyImplyLeading: true,
      ),
      body: Builder(builder: (BuildContext context) {
        Product product = widget.product;
        String serving = product.serve_size!;
        String? productServing = 'serving $serving';
        String? image = product.image;
        NutritionGoals? goals = NutritionGoals();
        return SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Row(children: [
                      if (image != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Image(
                            image: CachedNetworkImageProvider(image,
                                maxHeight: 120, maxWidth: 120),
                          ),
                        ),
                      Text(
                        product.productName!,
                        style: const TextStyle(
                          color: myColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ]),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Serving size: '),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedPortion,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPortion = newValue!;
                                print(selectedPortion);
                              });
                            },
                            items: <String?>[
                              oneGramorMl,
                              hundredGramOrMl,
                              if (product.serving_quantity != null)
                                productServing,
                            ].map<DropdownMenuItem<String>>((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value!),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Number of servings: '),
                        ),
                        Expanded(
                          child: TextField(
                            //controller: portionController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  portions = 1;
                                } else {
                                  portions = num.tryParse(value)!;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (selectedPortion != null)
                      Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child:
                                //Expanded(child:
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 8,
                                    itemBuilder: (context, index) {
                                      String? category;
                                      num? size;
                                      num? greenValue;
                                      num? amberValue;
                                      num? intake;
                                      switch (index) {
                                        case 0:
                                          {
                                            category = 'Calories';
                                            size = product.calories_100g;
                                            greenValue = null;
                                            amberValue = null;
                                            intake = goals.calories;
                                            break;
                                          }
                                        case 1:
                                          {
                                            category = 'Fat';
                                            size = product.fat_100g;
                                            greenValue = mtlValues.fatGreen;
                                            amberValue = mtlValues.fatAmber;
                                            intake = goals.fat;
                                            break;
                                          }
                                        case 2:
                                          {
                                            category = 'Saturates';
                                            size = product.sat_fat100g;
                                            greenValue = mtlValues.satFatGreen;
                                            amberValue = mtlValues.satFatAmber;
                                            intake = goals.saturates;
                                            break;
                                          }
                                        case 3:
                                          {
                                            category = 'Carbohydrates';
                                            size = product.carbs_100g;
                                            greenValue = null;
                                            amberValue = null;
                                            intake = goals.carbohydrates;
                                            break;
                                          }
                                        case 4:
                                          {
                                            category = 'Sugars';
                                            size = product.sugar_100g;
                                            greenValue = mtlValues.sugarGreen;
                                            amberValue = mtlValues.sugarAmber;
                                            intake = goals.sugars;
                                            break;
                                          }
                                        case 5:
                                          {
                                            category = 'Protein';
                                            size = product.protein_100g;
                                            greenValue = null;
                                            amberValue = null;
                                            intake = goals.protein;
                                            break;
                                          }
                                        case 6:
                                          {
                                            category = 'Salt';
                                            size = product.salt_100g;
                                            greenValue = mtlValues.saltGreen;
                                            amberValue = mtlValues.saltAmber;
                                            intake = goals.salt;
                                            break;
                                          }
                                        case 7:
                                          {
                                            category = 'Fibre';
                                            size = product.fibre_100g;
                                            greenValue = null;
                                            amberValue = null;
                                            intake = goals.fibre;
                                            break;
                                          }
                                      }
                                      if (selectedPortion ==
                                          '100$measurement' /*|| selectedPortion == '100ml'*/) {
                                        portion = 100;
                                      } else if (selectedPortion ==
                                          productServing) {
                                        portion = product.serving_quantity;
                                      } else if (selectedPortion ==
                                          '1$measurement' /*|| selectedPortion == '1ml'*/) {
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
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
