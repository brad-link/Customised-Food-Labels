import 'dart:convert';

import 'package:cfl_app/Wrapper.dart';
import 'package:cfl_app/appUser.dart';
import 'package:cfl_app/auth.dart';
import 'package:cfl_app/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cfl_app/product.dart';
import 'package:provider/provider.dart';
import 'NavigationService.dart';
import 'nutritionInfo.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(MyApp());
}


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
const myColor = Color(0xFF7B6AF2);
/*MaterialColor myColor = const MaterialColor(
  0xFF7B6AF2,
  <int, Color>{
    50: Color(0xFFE8E7F8),
    100: Color(0xFFC5C3E3),
    200: Color(0xFFA09CCE),
    300: Color(0xFF7B6AF2),
    400: Color(0xFF644DC9),
    500: Color(0xFF4D31A1),
    600: Color(0xFF372379),
    700: Color(0xFF1F1452),
    800: Color(0xFF0A002B),
    900: Color(0xFF00001B),
  },
);*/



class MyApp extends StatelessWidget {
  final Future<FirebaseApp> cflApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: Auth().user,
      child: MaterialApp(
        //navigatorKey: NavigationService.navigatorKey,
        //onGenerateRoute: ,
        theme: ThemeData(
          //primarySwatch: myColor,
          colorScheme: const ColorScheme(
            primary: myColor,
            onPrimary: Colors.white,
            secondary: myColor,
            onSecondary: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.grey,
            onSurface: Colors.black,
            brightness: Brightness.light,
            error: Colors.green,
            onError: Colors.green,
          ),

        ),
          debugShowCheckedModeBanner: false,
        home: Wrapper()
        // BarcodeScanner()
      ),
    );
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
      future: cflApp,
          builder: (context, snapshot){
        if (snapshot.hasError){
          print("Error! ${snapshot.error.toString()}");
          return Text("Something went wrong!");
        } else if (snapshot.hasData){
          return BarcodeScanner();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
          }

    )
    );*/
  }
}

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
      /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HttpScreen()),
      );*/
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

