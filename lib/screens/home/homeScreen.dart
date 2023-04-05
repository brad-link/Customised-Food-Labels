import 'package:cfl_app/components/customAppBar.dart';
import 'package:cfl_app/components/nutritionWidget.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/screens/home/logEntry.dart';
import 'package:cfl_app/screens/scannerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../../appUser.dart';
import '../../auth.dart';
import '../../components/dietLog.dart';

String scanBarcode = '';
bool codeScanned = false;

class HomeScreen extends StatefulWidget {
  //final List<DietLog> diary;
  //final int index;
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth _auth = Auth();
  late PageController controller = PageController();

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
    AppUser? user = Provider.of<AppUser?>(context, listen: false);
    return StreamBuilder<List<DietLog?>>(
        stream: DatabaseService(uid: user?.uid).nutritionTracker,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DietLog?> tracker = snapshot.data!;
          print(tracker);

          return PageView.builder(
            controller: controller,
            itemCount: tracker.length,
            itemBuilder: (context, index) {
              DietLog? day = tracker[index];
              DateTime? date = day?.date;
              num? cals = day?.calories;
              return Scaffold(
                appBar: CustomAppBar(
                  title: date.toString(),
                ),
                body: Builder(
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                        child: Container(
                      alignment: Alignment.center,
                      child: Flex(
                        direction: Axis.vertical,

                        children: [
                          Padding(padding: EdgeInsets.all(12.0),
                            child: Scanner(
                              scanButton: () {  },
                              displayButton: () {  },),

                          ),
                          Padding(padding: EdgeInsets.all(12.0),
                          child: IgnorePointer(
                            child: NutritionWidget(input: day),
                          ),
                          ),
                        ],
                      ),
                    ),
                    );
                  },
                ),
              );
              /* Container(
                  padding: EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$date'),
                      Text('$cals')
                    ],
                  ),
                );*/
            },
            onPageChanged: (index) {
              if (index < tracker.length) {
                DateTime? current = tracker[index]?.date;
                DateTime? next = tracker[index + 1]?.date;
                num difference = next?.difference(current!).inDays as num;
                if (difference > 1) {
                  controller.jumpToPage(index + 1);
                }
              }
            },
          );
        });

    /*return Scaffold(
      appBar: AppBar(
        title: Text('Food diary'),
      ),
      body: PageView.builder(
          controller: controller,
          itemCount: widget.diary.length,
          itemBuilder: (context, index){
            return LogEntry(entry: widget.diary[index]);
          }),

    );*/
  }
}
