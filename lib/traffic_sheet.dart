import 'package:cfl_app/DataClasses/appUser.dart';
import 'package:cfl_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'DataClasses/TrafficValues.dart';
import 'components/database.dart';

class TrafficSheet extends StatefulWidget {
  final num? green;
  final num? amber;
  final String? value;
  final int? choice;
  const TrafficSheet(
      {super.key,
      required this.choice,
      required this.green,
      required this.amber,
      required this.value});

  @override
  State<TrafficSheet> createState() => _TrafficSheetState();
}

class _TrafficSheetState extends State<TrafficSheet> {
  final _formKey = GlobalKey<FormState>();
  late num? _green;
  late num? _amber;
  late String? _value;

  @override
  void initState() {
    super.initState();
    _green = widget.green;
    _amber = widget.amber;
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Adjust $_value values\nper 100g:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
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
                          'Green: \n$_green',
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
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE56E00).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5),),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Amber: \n$_amber',
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
                  padding: const EdgeInsets.all(3.0),
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
                          'Red: \n>$_amber',
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
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
              child: Slider(
                value: _green!.toDouble(),
                min: 0,
                max: 100,
                onChanged: (double value) {
                  setState(() {
                    _green = num.parse(value.toStringAsFixed(2));
                    if (_green! > _amber!) {
                      _amber = num.parse(value.toStringAsFixed(2));
                    }
                  });
                },
                activeColor: const Color(0xFF29BF12),
                inactiveColor: const Color(0xFFDFF5DB),
              ),

          ),
          //Text('Green value for $_value < $_green /100g'),
          Container(
            width: double.infinity,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFFFBE9D9),
                inactiveTrackColor: const Color(0xFFE56E00),
                thumbShape: SliderComponentShape.noThumb,
              ),
              child: RangeSlider(
                values: RangeValues(_green!.toDouble(), _amber!.toDouble()),
                min: 0,
                max: 100,
                activeColor: const Color(0xFFE56E00),
                inactiveColor: const Color(0xFFFBE9D9),
                onChanged: (values) {
                  setState(() {
                    _green = num.parse(values.start.toStringAsFixed(2));
                    _amber = num.parse(values.end.toStringAsFixed(2));
                    if (_green! > _amber!) {
                      _green = num.parse(values.end.toStringAsFixed(2));
                    }
                  });
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Transform.rotate(
              angle: -math.pi,
              child: SliderTheme(
                data: SliderThemeData(
                  thumbShape: SliderComponentShape.noThumb,
                ),
                child: Slider(
                  value: 100 - _amber!.toDouble(),
                  min: 0,
                  max: 100,
                  activeColor: const Color(0xFFD90404),
                  inactiveColor: const Color(0xFFF9D9D9),
                  onChanged: (value) {
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              AppUser? user = Provider.of<AppUser?>(context, listen: false);
              TrafficValues? currentValues =
                  await DatabaseService(uid: user?.uid).getMTL();
              TrafficValues newValues = TrafficValues(
                fatGreen: widget.choice == 0 ? _green : currentValues?.fatGreen,
                fatAmber: widget.choice == 0 ? _amber : currentValues?.fatAmber,
                satFatGreen:
                    widget.choice == 1 ? _green : currentValues?.satFatGreen,
                satFatAmber:
                    widget.choice == 1 ? _amber : currentValues?.satFatAmber,
                sugarGreen:
                    widget.choice == 2 ? _green : currentValues?.sugarGreen,
                sugarAmber:
                    widget.choice == 2 ? _amber : currentValues?.sugarAmber,
                saltGreen:
                    widget.choice == 3 ? _green : currentValues?.saltGreen,
                saltAmber:
                    widget.choice == 3 ? _amber : currentValues?.saltAmber,
              );
              await DatabaseService(uid: user?.uid).setMTL(newValues);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          ElevatedButton(onPressed: () { Navigator.pop(context);},
              child: const Text('cancel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: myColor.withOpacity(0.15),
          ),)
        ],
      ),
    );
  }
}
