import 'package:cfl_app/main.dart';
import 'package:cfl_app/traffic_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrafficCard2 extends StatelessWidget {
  final num? value1;
  final num? value2;
  final String? category;
  final int? choice;

  const TrafficCard2({Key? key, this.value1, this.value2, this.category, this.choice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? greenValue = value1?.toStringAsFixed(2);
    String? amberValue = value2?.toStringAsFixed(2);
    void nutritionSettings() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
              child:  TrafficSheet(
                choice: choice,
                green: value1,
                amber: value2,
                value: category,
              ),
            );
          });
    }

    return GestureDetector(
      onTap: () {
        nutritionSettings();
      },
      child:
      Padding(padding: EdgeInsets.all(5),
      child:Container(
        decoration: BoxDecoration(
          color: myColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                textAlign: TextAlign.center,
                '$category values per 100g',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            //Divider(),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                padding: EdgeInsets.all(2) ,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black)),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Green: \n$greenValue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ),
                  /*SizedBox(
                    width: 16.0,
                  ),*/
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          //color: myColor,
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black)),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Amber: \n$amberValue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          //color: myColor,
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black)),
                      //color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Red: \n>$amberValue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
