import 'dart:convert';

import 'package:cfl_app/productSearch.dart';
import 'package:cfl_app/search_productdb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../addProduct.dart';
import '../../DataClasses/appUser.dart';
import '../../DataClasses/nutritionGoals.dart';
import '../../database.dart';
import '../../DataClasses/product.dart';
import '../../tabbed_search.dart';
import '../ScannedScreen2.dart';
import '../not_custom_scanned.dart';

String scanBarcode = '';
bool codeScanned = false;
bool productExists = false;

class DefaultScanner extends StatefulWidget {
  //final DateTime date;
  final VoidCallback scanButton;
  final VoidCallback displayButton;
  const DefaultScanner({Key? key, required this.scanButton, required this.displayButton}) : super(key: key);

  @override
  State<DefaultScanner> createState() => _DefaultScannerState();
}

class _DefaultScannerState extends State<DefaultScanner> {



  Future startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future barcodeScan(NutritionGoals? nutriGoals) async {
    productExists = false;
    String scanResult;
    List<Product> savedProducts = await DatabaseService().getSavedProductsFuture();
    widget.scanButton;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult = 'Scan failed';
    }
    if (!mounted) {
      setState(() {
        codeScanned = false;
      });
      return;
    }
    if(scanResult != '-1'){
      for(int i=0; i<savedProducts.length; i++) {
        if (scanResult == savedProducts[i].code) {
          Product product = savedProducts[i];
          productExists = true;
          if(!mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NotLoggedInScan(product: product)));
          break;
        }
      }
      final url =
          "https://world.openfoodfacts.org/api/v0/product/$scanResult.json";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && productExists == false) {
        final jsonProduct = jsonDecode(response.body);
        if (jsonProduct['status'] == 1) {
          Product product = Product.fromJson(jsonProduct);
          if(!mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NotLoggedInScan(product: product)));
        } else {
          if (!mounted) return;
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Product Not Found'),
              content: const Text('Unfortunately this product is not in our databases'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss')),
              ],
            );
          });

          //productExists = false;
        }
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
                key: const Key('scan'),
                height: 40,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      NutritionGoals? goals = NutritionGoals();
                      barcodeScan(goals);},
                    icon: const Icon(CupertinoIcons.barcode),
                    label: const Text('Barcode Scan',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
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
                              builder: (context) => ProductSearch(currentDate: DateTime.now()) /*HttpScreen(scanBarcode: scanBarcode, mtlValues: currentValues,)*/),
                        );
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Search Products',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))),
              ),
            ]));
  }
}
