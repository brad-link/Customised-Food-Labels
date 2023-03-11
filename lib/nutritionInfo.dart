import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cfl_app/product.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

int ref_calories = 2000;
int ref_fat = 70;
int ref_carbs = 260;
int ref_sugars = 90;
int ref_protein = 50;
int ref_salt = 6;
int ref_saturates = 20;
//String _scanBarcode = '';
bool codeScanned = false;
String? productID = '';

class HttpScreen extends StatelessWidget {
  final String scanBarcode;
  const HttpScreen({
    Key? key,
    required this.scanBarcode,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Information'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Builder(builder: (BuildContext context){
        return Container(
          alignment: Alignment.center,
          child: Flex(
              direction: Axis.vertical,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FutureBuilder<Product>(
                    future: getProduct(scanBarcode),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        var product = snapshot.data;
                        final num cal_portion = product?.calories ?? 0;
                        final num cal_100 = product?.calories_100g ?? 0;
                        final num carbs_portion = product?.carbs ?? 0;
                        final num carbs_100 = product?.carbs_100g ?? 0;
                        final num fat_portion = product?.fat ?? 0;
                        final num fat_100 = product?.fat_100g ?? 0;
                        final num sugar_portion = product?.sugar ?? 0;
                        final num sugar_100 = product?.sugar_100g ?? 0;
                        final num protein_portion = product?.protein ?? 0;
                        final num protein_100 = product?.protein_100g ?? 0;
                        final num salt_portion = product?.salt ?? 0;
                        final num salt_100 = product?.salt_100g ?? 0;
                        // final num satFat_portion = product?.satFat ?? 0;
                        // final num satFat_100 = product?.satFat_100g ?? 0;
                        final num cal_ref_portion = (cal_portion/ref_calories)*100;
                        final num carbs_ref_portion = (carbs_portion/ref_carbs)*100;
                        final num fat_ref_portion = (fat_portion/ref_fat)*100;
                        final num sugar_ref_portion = (sugar_portion/ref_sugars)*100;
                        final num salt_ref_portion = (salt_portion/ref_salt)*100;
                        final num protein_ref_portion = (protein_portion/ref_protein)*100;
                        final num cal_ref_100g = (cal_100/ref_calories)*100;
                        final num carbs_ref_100g = (carbs_100/ref_carbs)*100;
                        final num fat_ref_100g = (fat_100/ref_fat)*100;
                        final num sugar_ref_100g = (sugar_100/ref_sugars)*100;
                        final num salt_ref_100g = (salt_100/ref_salt)*100;
                        final num protein_ref_100g = (protein_100/ref_protein)*100;
                        //final num satFat_ref_portion = (satFat_portion/ref_sat)*100;
                        //final num satFat_ref_100g = (satFat_100/ref_sat)*100;
                        productID = product?.productName;
                        String? serving = '';
                        num? saturates = 0;
                        num? saturateRef = 0;
                        num? saturateref100 = 0;
                        num? saturates_100 = 0;
                        if(product?.satFat != null){
                          saturates = product?.satFat ?? 0;
                          num saturateRef = (saturates/ref_saturates)*100 ;
                        } else if(product?.sat_fat != null){
                          saturates = product?.sat_fat ?? 0;
                          num saturateRef = (saturates/ref_saturates)*100 ;
                        }
                        if(product?.satFat_100g != null){
                          saturates_100 = product?.satFat_100g ?? 0;
                          num saturateRef100 = (saturates_100/ref_saturates)*100 ;
                        } else if(product?.sat_fat100g != null){
                          saturates_100 = product?.sat_fat100g ?? 0;
                          num saturateRef100 = (saturates_100/ref_saturates)*100;
                        }
                        if(product?.serve_size != null){
                          serving = product?.serve_size;
                        } else if(product?.quantity != null){
                          serving = product?.quantity;
                        }


                        return Container(
                          child: Flex(
                            direction: Axis.vertical,
                            children: <Widget>[
                              Text('Product: $productID',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold
                                ),),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child:DataTable(columns:[
                                  DataColumn(label: Container(
                                    child: Text(''),
                                  ),),
                                  DataColumn(label: Container(
                                    child: Text('Per\nportion $serving'),
                                  ),),
                                  DataColumn(label: Container(
                                    child: Text('per\n100g'),),
                                  ),
                                  DataColumn(label: Container(
                                    child: Text('%RI\n(Portion)'),
                                  )
                                  ),
                                  DataColumn(label: Container(
                                    child: Text('%RI\n(100g)'),
                                  )
                                  )
                                ], rows: [
                                  DataRow(cells: [
                                    DataCell(Text('Calories')),
                                    DataCell(Text('${cal_portion.toStringAsFixed(1)}')),
                                    DataCell(Text('${cal_100.toStringAsFixed(1)}')),
                                    DataCell(Text('${cal_ref_portion.round()}%')),
                                    DataCell(Text('${cal_ref_100g.round()}%')),
                                  ]),
                                  DataRow(
                                      cells: [
                                        DataCell(Text('Carbohydrates')),
                                        DataCell(Text('${carbs_portion.toStringAsFixed(1)}')),
                                        DataCell(Text('${carbs_100.toStringAsFixed(1)}')),
                                        DataCell(Text('${carbs_ref_portion.round()}%')),
                                        DataCell(Text('${carbs_ref_100g.round()}%')),
                                      ]),
                                  DataRow(
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states){
                                            num fatCheck = product?.fat_100g ?? 0;
                                            if(fatCheck <= 3){
                                              return Colors.green.withOpacity(0.4);
                                            } else if(fatCheck < 17.5){
                                              return Colors.orange.withOpacity(0.4);
                                            } else{
                                              return Colors.red.withOpacity(0.4);
                                            }

                                          }
                                      ),
                                      cells: [
                                        DataCell(Text('Fat ')),
                                        DataCell(Text('${fat_portion.toStringAsFixed(1)}')),
                                        DataCell(Text('${fat_100.toStringAsFixed(1)}')),
                                        DataCell(Text('${fat_ref_portion.round()}%')),
                                        DataCell(Text('${fat_ref_100g.round()}%')),
                                      ]),
                                  DataRow(
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states){
                                            num satFatCheck = product?.satFat_100g ?? 0;
                                            if(satFatCheck <= 1.5){
                                              return Colors.green.withOpacity(0.4);
                                            } else if(satFatCheck < 5){
                                              return Colors.orange.withOpacity(0.4);
                                            } else{
                                              return Colors.red.withOpacity(0.4);
                                            }

                                          }
                                      ),
                                      cells: [
                                        DataCell(Text('Saturated Fat')),
                                        DataCell(Text('${saturates.toStringAsFixed(1)}')),
                                        DataCell(Text('${saturates_100.toStringAsFixed(1)}')),
                                        DataCell(Text('${saturateRef.round()}%')),
                                        DataCell(Text('${saturateref100.round()}%')),
                                      ]),
                                  DataRow(

                                      cells: [
                                        DataCell(Text('Protein')),
                                        DataCell(Text('${protein_portion.toStringAsFixed(1)}')),
                                        DataCell(Text('${protein_100.toStringAsFixed(1)}')),
                                        DataCell(Text('${protein_ref_portion.round()}%')),
                                        DataCell(Text('${protein_ref_100g.round()}%')),
                                      ]),
                                  DataRow(
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states){
                                            num sugarCheck = product?.sugar_100g ?? 0;
                                            if(sugarCheck <= 5){
                                              return Colors.green.withOpacity(0.4);
                                            } else if(sugarCheck <= 22.5){
                                              return Colors.orange.withOpacity(0.4);
                                            } else{
                                              return Colors.red.withOpacity(0.4);
                                            }

                                          }
                                      ),
                                      cells: [
                                        DataCell(Text('Sugar')),
                                        DataCell(Text('${sugar_portion.toStringAsFixed(1)}')),
                                        DataCell(Text('${sugar_100.toStringAsFixed(1)}')),
                                        DataCell(Text('${sugar_ref_portion.round()}%')),
                                        DataCell(Text('${sugar_ref_100g.round()}%')),
                                      ]),
                                  DataRow(
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states){
                                            num saltCheck = product?.salt_100g ?? 0;
                                            if(saltCheck <= 0.3){
                                              return Colors.green.withOpacity(0.4);
                                            } else if(saltCheck <= 1.5){
                                              return Colors.orange.withOpacity(0.4);
                                            } else{
                                              return Colors.red.withOpacity(0.4);
                                            }

                                          }
                                      ),
                                      cells: [
                                        DataCell(Text('Salt')),
                                        DataCell(Text('${salt_portion.toStringAsFixed(1)}')),
                                        DataCell(Text('${salt_100.toStringAsFixed(1)}')),
                                        DataCell(Text('${salt_ref_portion.round()}%')),
                                        DataCell(Text('${salt_ref_100g.round()}%')),
                                      ]),
                                ]
                                ),
                              ),
                            ],),
                        );


                        //return Text("Barcode : ${product?.code} \n name : ${product?.productName} \n calories: ${product?.calories}");

                      }else if(snapshot.hasError){
                        return Text('Unable to retrieve nutritional information');
                      }

                      return CircularProgressIndicator();

                    }),
                // Text('product: $productID'),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Go Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                )

              ]),
        );

      }
      ),
    );
  }
}

Future<Product> getProduct(scanBarcode) async{
  final url = "https://world.openfoodfacts.org/api/v0/product/$scanBarcode.json";
  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200){
    final jsonProduct = jsonDecode(response.body);
    return Product.fromJson(jsonProduct);
  }else{
    throw Exception();
  }

}