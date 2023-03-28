import 'package:cfl_app/appUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TrafficValues.dart';
import 'database.dart';

class TrafficSheet extends StatefulWidget {
  final num? green;
  final num? amber;
  final String? value;
  final int? choice;
  const TrafficSheet({super.key, required this.choice, required this.green, required this.amber, required this.value});

  @override
  _TrafficSheetState createState() => _TrafficSheetState();
}

class _TrafficSheetState extends State<TrafficSheet> {
  final _formKey = GlobalKey<FormState>();
  late num? _green;
  late num? _amber;
  late String? _value;
  late int? _choice;

  @override
  void initState(){
    super.initState();
    _green = widget.green;
    _amber = widget.amber;
    _value = widget.value;
    _choice = widget.choice;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Adjust $_value values:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
          child: RangeSlider(
            values: RangeValues(0, _green!.toDouble()),
            min: 0,
            max: 100,
            onChanged: (RangeValues values) {
              setState(() {
                _green = values.end;
                if(_green! > _amber!){
                  _amber = values.end;
                }
              });
            },
            activeColor: Colors.green,
            //key: 'Green value Limit',
            divisions: 200,
          ),
          ),
          Text('Green value for $_value < $_green /100g'),
          Container(
            width: double.infinity,
          child: RangeSlider(
            values: RangeValues(_green!.toDouble(),_amber!.toDouble()),
            min: 0,
            max: 100,
            onChanged: (values) {
              setState(() {
                _amber = values.end;
                if(_green! > _amber!){
                  _green = values.end;
                }
              });
            },
          ),
          ),

          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              print('choice $_choice');
      /*switch (_choice) {
        case 0:
          {
            await DatabaseService().updateMTL('fatGreen', 'fatAmber', _green!, _amber!);
            break;
          }
        case 1:
          {
            await DatabaseService().updateMTL('satFatGreen', 'satFatAmber', _green!, _amber!);
            break;
          }
        case 2:
          {
            await DatabaseService().updateMTL('sugarGreen', 'sugarAmber', _green!, _amber!);
            break;
          }
        case 3:
          {
            await DatabaseService().updateMTL('sugarGreen', 'sugarAmber', _green!, _amber!);
            break;
          }
      }*/
              AppUser? user = Provider.of<AppUser?>(context, listen: false);
              TrafficValues? currentValues = await DatabaseService(uid: user?.uid).getMTL();
              TrafficValues newValues = TrafficValues(
                fatGreen: widget.choice == 0 ? _green : currentValues?.fatGreen,
                fatAmber: widget.choice == 0 ? _amber : currentValues?.fatAmber,
                satFatGreen: widget.choice == 1 ? _green : currentValues?.satFatGreen,
                satFatAmber: widget.choice == 1 ? _amber : currentValues?.satFatAmber,
                sugarGreen: widget.choice == 2 ? _green : currentValues?.sugarGreen,
                sugarAmber: widget.choice == 2 ? _amber : currentValues?.sugarAmber,
                saltGreen: widget.choice == 3 ? _green : null,
                saltAmber: widget.choice == 3 ? _amber : null,
              );
              await DatabaseService(uid: user?.uid).setMTL(newValues);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
