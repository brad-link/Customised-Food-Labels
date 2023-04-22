import 'dart:convert';


import 'package:cfl_app/components/nutritionGoals.dart';
import 'package:cfl_app/productSearch.dart';
import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../TrafficValues.dart';
import '../addProduct.dart';
import '../appUser.dart';
import '../database.dart';
import '../product.dart';
import '../tabbed_search.dart';
import 'ScannedScreen2.dart';

String scanBarcode = '';
bool codeScanned = false;
bool productExists = true;

class Scanner extends StatefulWidget {
  final DateTime date;
  final VoidCallback scanButton;
  final VoidCallback displayButton;
  const Scanner({Key? key, required this.scanButton, required this.displayButton, required this.date}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {



  Future startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future barcodeScan(NutritionGoals? nutriGoals) async {
    String barcodeScanRes;
    List<Product> savedProducts = await DatabaseService().getSavedProductsFuture();
    widget.scanButton;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) {
      setState(() {
        codeScanned = false;
      });
      return;
    }


    for(int i=0; i<savedProducts.length; i++) {
      if (barcodeScanRes == savedProducts[i].code) {
        Product product = savedProducts[i];
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ScannedScreen(
              product: product, date: widget.date!, goals: nutriGoals,)));
        break;
      }
    }
    final url =
        "https://world.openfoodfacts.org/api/v0/product/$barcodeScanRes.json";
    final response = await http.get(Uri.parse(url));


    if (response.statusCode == 200) {
      final jsonProduct = jsonDecode(response.body);
      if(jsonProduct['status'] == 1){
      Product product = Product.fromJson(jsonProduct);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScannedScreen(product: product, date: widget.date!, goals: nutriGoals,)));
    } else {
        Product newProduct = Product();
      print('Barcode ERROR');
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Product Not Found'),
          content: const Text('Add the product to the databse?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context),
                child: const Text('No')),
            TextButton(
                onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(barcode: barcodeScanRes, product: newProduct, currentDate: widget.date,))),
                child: const Text('Add')),
          ],
        );
      });
        //productExists = false;
    }
    } else{
        throw Exception('failed to load data');
    }
    }


  @override
  Widget build(BuildContext context) {
    AppUser? user = Provider.of<AppUser?>(context, listen: false);
    return Container(
      height: 200,
        width: 200,
        alignment: Alignment.center,
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                       // backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        NutritionGoals? goals = await DatabaseService(uid: user?.uid).getNutritionGoals();
                        barcodeScan(goals);},
                      child: const Text('Barcode Scan',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold))),
                ),
             SizedBox(
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                     // backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      widget.displayButton;
                            final navigator = context;
                            if (mounted) {
                              Navigator.push(
                                navigator,
                                MaterialPageRoute(
                                    builder: (context) => TabbedSearch(currentDate: widget.date,) /*HttpScreen(scanBarcode: scanBarcode, mtlValues: currentValues,)*/),
                              );
                            }
                          },
                    child: const Text('Search Products',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))),
              ),
            ]));
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
