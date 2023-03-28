import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../loginScreen.dart';
import '../../nutritionInfo.dart';

int ref_calories = 2000;
int ref_fat = 70;
int ref_carbs = 260;
int ref_sugars = 90;
int ref_protein = 50;
int ref_salt = 6;
int ref_saturates = 20;
String scanBarcode = '';
bool codeScanned = false;
String? productID = '';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key}) : super(key: key);
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}
class _BarcodeScannerState extends State<BarcodeScanner> {
  //String _scanBarcode = 'Unknown';
  /// For Continuous scan
  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }
  Future<void> barcodeScan() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      scanBarcode = barcodeScanRes;
      codeScanned = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Barcode SCANNER'),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          actions: [
            PopupMenuButton<int>(itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Text("Sign in")
                  ],
                ),
              ),
            ],
              onSelected: (value){
                if (value== 1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              icon: Icon(Icons.account_circle,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    /*const SizedBox(
                      height: 50,
                    ),
                    Text('Scan result : $_scanBarcode\n',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),*/
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () => barcodeScan(),
                          child: const Text('Barcode Scan',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold))),
                    ),
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: codeScanned ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HttpScreen(scanBarcode: scanBarcode, mtlValues: null,)),
                            );
                          } : null,
                          child: const Text('Show Nutritional data',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold))),

                    )]));
        }));
  }
}