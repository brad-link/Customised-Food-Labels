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
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
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
      Padding(padding: const EdgeInsets.all(5),
      child:Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black.withOpacity(0.1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                textAlign: TextAlign.center,
                '$category values per 100g',
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Fig-tree',
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
                padding: const EdgeInsets.all(4) ,
                    child: Container(
                      decoration:  BoxDecoration(
                          color: const Color(0xFF29BF12).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(5),),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Green: \n$greenValue',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF29BF12),
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
                          color: Color(0xFFE56E00).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(5),),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Amber: \n$amberValue',
                            style: const TextStyle(
                              color: Color(0xFFE56E00),
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
                          color: const Color(0xFFD90404).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(5),
                      ),
                      //color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Red: \n>$amberValue',
                            style: const TextStyle(
                              color: Color(0xFFD90404),
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
