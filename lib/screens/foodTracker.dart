import 'package:cfl_app/components/dietLog.dart';
import 'package:cfl_app/screens/scannedScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../TrafficValues.dart';
import '../appUser.dart';
import '../auth.dart';
import '../database.dart';
import '../traffic_settings.dart';
import 'home/settings_form.dart';

bool codeScanned = false;
String scanBarcode = '';

class FoodTracker extends  StatefulWidget {
  final DietLog date;
  FoodTracker({Key? key, required this.date}) : super(key: key);

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
  State<FoodTracker> createState() => _FoodTrackerState();
}

class _FoodTrackerState extends State<FoodTracker> {
  final Auth _auth = Auth();
  @override
  Widget build(BuildContext context) {
    void _showSettings(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: const SettingsForm(),
        );
      });
    }
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
                    Text("Account settings")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Text("update nutrition preferences")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Text("Sign out")
                  ],
                ),
              ),
            ],
              onSelected: (value) async{
                if (value==1){
                  _showSettings();
                }
                if (value==2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrafficSettings()),
                  );
                  //nutritionSettings();
                }
                if(value== 3){
                  await _auth.signOut();
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
        }));
  }
}
