import 'package:cfl_app/components/nutritionWidget.dart';
import 'package:cfl_app/dailyProducts.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/screens/scannerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/appUser.dart';
import '../../components/auth.dart';
import '../../components/custom_app_bar.dart';
import '../../DataClasses/dietLog.dart';

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
  late PageController controller;
  late String title;
  late DateTime chosenDate;

  @override
  initState(){
    super.initState();
    chosenDate = DateTime.now();

  }

  Future chooseDate(BuildContext context, DateTime firstDate, DateTime currentDate, List<DietLog> tracker) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: firstDate,
        lastDate: DateTime.now(),
    );
    if(picked != null && picked != chosenDate){
      setState(() {
        chosenDate = picked;
      });
      getEntry(tracker, chosenDate);
    }
  }

   getEntry(List<DietLog> tracker, DateTime chosenDate){
    int chosenIndex = 0;
    for(int i = 0; i < tracker.length; i++){
      if(tracker[i].date == chosenDate){
        chosenIndex = i;
      }
      controller.animateToPage(
          chosenIndex,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
    }
  }

  /// For Continuous scan
  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> barcodeScan() async {
    String barcodeScanRes;
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
    return StreamBuilder<List<DietLog>>(
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

          List<DietLog> tracker = snapshot.data!;
          checkIfExists(tracker, user!);
          controller = PageController(initialPage: 1);
          DateTime firstDate = tracker.last.date;

          return PageView.builder(
            controller: controller,
            reverse: true,
            itemCount: tracker.length,
            itemBuilder: (context, index) {
              DietLog? day = tracker[index];
              DateTime? date = day.date;
              String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
              String tomorrow = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: 1)));
              String yesterday = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(Duration(days: 1)));
              String dateString = DateFormat('dd-MM-yyyy').format(day.date);
              if(dateString == today){
                title = 'Today';
              } else if(dateString == yesterday){
                title = 'Yesterday';
              } else if(dateString == tomorrow){
                title = 'Tomorrow';
              }else{
                title = DateFormat('d MMMM y').format(date!);
              }
              return Scaffold(
                appBar: CustomAppBar(
                  title: title,
                  backButton: false,
                  calendar: IconButton(
                      onPressed: () => chooseDate(context, firstDate, date!, tracker),
                      icon: const Icon(Icons.calendar_today)),
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
                            child: Scanner(date: date!,
                              scanButton: () {  },
                              displayButton: () {  },),

                          ),
                          Padding(padding: EdgeInsets.all(12.0),
                          child: IgnorePointer(
                            child: NutritionWidget(input: day),
                          ),
                          ),
                          Padding(padding: EdgeInsets.all(12.0),
                              child: DailyProducts(currentDate: date,),
                          ),
                        ],
                      ),
                    ),
                    );
                  },
                ),
              );
            },
          );
        });
  }

  void checkIfExists(List<DietLog> tracker, AppUser user) async{
    DateTime lastEntry = tracker[0].date;
    DateTime now = DateTime.now();
    if(lastEntry != now){
      while(lastEntry.isBefore(now)){
        lastEntry = lastEntry.add(Duration(days: 1));
        DietLog newEntry = DietLog(date: lastEntry);
        await DatabaseService(uid: user.uid).createLog(newEntry);
      }
    }
  }
}
