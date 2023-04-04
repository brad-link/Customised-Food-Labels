import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../TrafficValues.dart';
import '../appUser.dart';
import '../database.dart';
/*
class ScannedScreen2 extends StatefulWidget {
  final String scanBarcode;
  const ScannedScreen2({Key? key, required this.scanBarcode}) : super(key: key);

  @override
  State<ScannedScreen2> createState() => _ScannedScreen2State();
}

class _ScannedScreen2State extends State<ScannedScreen2> {
  bool servingChecked = false;
  bool gramsChecked = false;
  @override
  Widget build(BuildContext context) {
    AppUser? user = Provider.of<AppUser?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Information'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          CheckboxListTile(
            title: Text('per 100g'),
            value: gramsChecked,
            onChanged: (value) {
              setState(() {
                gramsChecked = value!;
                servingChecked = false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('per serving'),
            value: servingChecked,
            onChanged: (value) {
              setState(() {
                servingChecked = value!;
                gramsChecked = false;
              });
            },
          ),
          if (gramsChecked)
            FutureBuilder<TrafficValues?>(
                future: DatabaseService(uid: user?.uid).getMTL(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    TrafficValues? mtlValues = snapshot?.data;
                    return ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          num? serving;
                          String? category;
                          num? size;
                          num? greenValue;
                          num? amberValue;
                          num? intake;
                          switch (index) {
                            case 0:
                              {
                                serving = 100;
                                category = 'Fat';
                                size = product?.fat_100g;
                                greenValue = mtlValues?.fatGreen;
                                amberValue = mtlValues?.fatAmber;
                                intake = 70;
                                break;
                              }
                            case 1:
                              {
                                serving = 100;
                                category = 'Saturates';
                                size = product?.sat_fat100g;
                                greenValue = mtlValues?.satFatGreen;
                                amberValue = mtlValues?.satFatAmber;
                                intake = 20;
                                break;
                              }
                            case 2:
                              {
                                serving = 100;
                                category = 'Sugars';
                                size = product?.sugar_100g;
                                greenValue = mtlValues?.sugarGreen;
                                amberValue = mtlValues?.sugarAmber;
                                intake = 90;
                                break;
                              }
                            case 3:
                              {
                                serving = 100;
                                category = 'Salt';
                                size = product?.salt_100g;
                                greenValue = mtlValues?.saltGreen;
                                amberValue = mtlValues?.saltAmber;
                                intake = 70;
                                break;
                              }
                          }
                          return ValueCard(
                            serving: serving,
                            category: category,
                            size: size,
                            greenValue: greenValue,
                            amberValue: amberValue,
                            intake: intake,
                          );
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          if (_showList2)
            FutureBuilder<List<String>>(
              future: fetchDataForList2(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data[index]),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
        ],
      ),
    );
  }
}*/
