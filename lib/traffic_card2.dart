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
      child: Container(
        decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(
                '$category values per 100g',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            //Divider(),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Green: \n$greenValue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*SizedBox(
                    width: 16.0,
                  ),*/
                  Expanded(
                    child: Container(
                      color: Colors.amber,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amber: \n$amberValue',
                            style: TextStyle(

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Red: \n>$amberValue',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
