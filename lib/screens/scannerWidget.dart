import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../TrafficValues.dart';
import '../appUser.dart';
import '../database.dart';

String scanBarcode = '';
bool codeScanned = false;

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

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
    return Container(
        alignment: Alignment.center,
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
                child: ElevatedButton (
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: codeScanned ? () async {
                      final navigator = context;
                      AppUser? user = Provider.of<AppUser?>(context, listen: false);
                      TrafficValues? currentValues = await DatabaseService(uid: user?.uid).getMTL();
                      if(mounted){
                        Navigator.push(
                          navigator,
                          MaterialPageRoute(builder: (context) => ScannedScreen(scanBarcode: scanBarcode) /*HttpScreen(scanBarcode: scanBarcode, mtlValues: currentValues,)*/),
                        );
                      }
                    } : null,
                    child: const Text('Show Nutritional data',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))),

              )]));
  }
}
