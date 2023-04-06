import 'dart:convert';

import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../TrafficValues.dart';
import '../appUser.dart';
import '../database.dart';
import '../product.dart';
import 'ScannedScreen2.dart';

String scanBarcode = '';
bool codeScanned = false;
bool productExists = true;

class Scanner extends StatefulWidget {
  final VoidCallback scanButton;
  final VoidCallback displayButton;
  const Scanner({Key? key, required this.scanButton, required this.displayButton}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  Future startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future barcodeScan() async {
    String barcodeScanRes;
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
    final url =
        "https://world.openfoodfacts.org/api/v0/product/$barcodeScanRes.json";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonProduct = jsonDecode(response.body);
      Product product = Product.fromJson(jsonProduct);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScannedScreen(product: product)));
    } else {
      setState(() {
        productExists = false;
      });
    }
    }


  @override
  Widget build(BuildContext context) {
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
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () => barcodeScan(),
                      child: const Text('Barcode Scan',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold))),
                ),
             if(productExists == false)
             Text('Product not found in Database'),
             /* SizedBox(
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: codeScanned
                        ? () async {
                      widget.displayButton;
                            final navigator = context;
                            if (mounted) {
                              Navigator.push(
                                navigator,
                                MaterialPageRoute(
                                    builder: (context) => ScannedScreen(
                                        scanBarcode:
                                            scanBarcode) /*HttpScreen(scanBarcode: scanBarcode, mtlValues: currentValues,)*/),
                              );
                            }
                          }
                        : null,
                    child: const Text('Show Nutritional data',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))),
              ),*/
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
