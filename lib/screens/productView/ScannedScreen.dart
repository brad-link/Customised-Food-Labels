import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfl_app/components/add_product_to_db.dart';
import 'package:cfl_app/DataClasses/nutritionGoals.dart';
import 'package:cfl_app/components/database.dart';
import 'package:cfl_app/DataClasses/product.dart';
import 'package:cfl_app/valueCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../DataClasses/TrafficValues.dart';
import '../addProductScreen/addProduct.dart';
import '../../DataClasses/appUser.dart';
import '../../main.dart';

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
    AppUser? user = Provider.of<AppUser?>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Nutrition Information'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: myColor,
        ),
        body: Builder(builder: (BuildContext context) {
          Product product = widget.product;
          String serving = product.serve_size!;
          String? productServing = 'serving $serving';
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        if (image != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Image(
                              image: CachedNetworkImageProvider(image,
                                  maxHeight: 120, maxWidth: 120),
                            ),
                          ),
                        Center(
                        child: Text('Product name: \n${product.productName!} ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            //color: myColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
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
                                  //checked = selectedPortion;
                                  //portion = double.parse(selectedPortion!);
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
                        StreamBuilder<TrafficValues?>(
                            stream:
                                DatabaseService(uid: user?.uid).getMTLStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                TrafficValues? mtlValues = snapshot.data;
                                return Column(children: [
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
                                                    size =
                                                        product.calories_100g;
                                                    greenValue = null;
                                                    amberValue = null;
                                                    intake =
                                                        personalGoals?.calories;
                                                    break;
                                                  }
                                                case 1:
                                                  {
                                                    category = 'Fat';
                                                    size = product.fat_100g;
                                                    greenValue =
                                                        mtlValues?.fatGreen;
                                                    amberValue =
                                                        mtlValues?.fatAmber;
                                                    intake = personalGoals?.fat;
                                                    break;
                                                  }
                                                case 2:
                                                  {
                                                    category = 'Saturates';
                                                    size = product.sat_fat100g;
                                                    greenValue =
                                                        mtlValues?.satFatGreen;
                                                    amberValue =
                                                        mtlValues?.satFatAmber;
                                                    intake = personalGoals
                                                        ?.saturates;
                                                    break;
                                                  }
                                                case 3:
                                                  {
                                                    category = 'Carbohydrates';
                                                    size = product.carbs_100g;
                                                    greenValue = null;
                                                    amberValue = null;
                                                    intake = personalGoals
                                                        ?.carbohydrates;
                                                    break;
                                                  }
                                                case 4:
                                                  {
                                                    category = 'Sugars';
                                                    size = product.sugar_100g;
                                                    greenValue =
                                                        mtlValues?.sugarGreen;
                                                    amberValue =
                                                        mtlValues?.sugarAmber;
                                                    intake =
                                                        personalGoals?.sugars;
                                                    break;
                                                  }
                                                case 5:
                                                  {
                                                    category = 'Protein';
                                                    size =
                                                        product.protein_100g;
                                                    greenValue = null;
                                                    amberValue = null;
                                                    intake =
                                                        personalGoals?.protein;
                                                    break;
                                                  }
                                                case 6:
                                                  {
                                                    category = 'Salt';
                                                    size = product.salt_100g;
                                                    greenValue =
                                                        mtlValues?.saltGreen;
                                                    amberValue =
                                                        mtlValues?.saltAmber;
                                                    intake =
                                                        personalGoals?.salt;
                                                    break;
                                                  }
                                                case 7:
                                                  {
                                                    category = 'Fibre';
                                                    size = product.fibre_100g;
                                                    greenValue = null;
                                                    amberValue = null;
                                                    intake =
                                                        personalGoals?.fibre;
                                                    break;
                                                  }
                                              }
                                              if (selectedPortion ==
                                                  '100$measurement' /*|| selectedPortion == '100ml'*/) {
                                                portion = 100;
                                              } else if (selectedPortion ==
                                                  productServing) {
                                                portion =
                                                    product.serving_quantity;
                                                print(
                                                    product.serving_quantity);
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
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: myColor),
                                      onPressed: () async {
                                        AddProductToDB addToDB =
                                            AddProductToDB();
                                        product.setServingMacros(product);
                                        //await DatabaseService(uid: user?.uid).
                                        addToDB.add(user!, widget.date, product,
                                            portion, portions);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Add to Diary')),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: TextButton(
                                      child: const Text(
                                          'incorrect data? update values'),
                                      onPressed: () =>
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddProduct(
                                                        barcode: product.code!,
                                                        product: product,
                                                        currentDate:
                                                            widget.date,
                                                      ))),
                                    ),
                                  )
                                ]);
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
}
