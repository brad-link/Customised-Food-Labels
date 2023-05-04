import 'package:cfl_app/DataClasses/TrafficValues.dart';
import 'package:cfl_app/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/appUser.dart';
import '../../database.dart';
class SettingsForm2 extends StatefulWidget {
  const SettingsForm2({Key? key}) : super(key: key);

  @override
  State<SettingsForm2> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm2> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  num? _currentWeight;
  num? _height;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return StreamBuilder<UserData?>(
      stream: DatabaseService(uid: user?.uid).getUser(),
      builder: (context, snapshot){
        if(snapshot.hasData) {
          UserData? userInfo = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  const Text(
                    'Update Account details',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  TextFormField(
                    initialValue: userInfo?.weight.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        labelText: 'Current weight(kg): ',
                    ),
                    validator: (value) =>value!.isEmpty ? "enter your weight" : null,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        _currentWeight = null;
                      } else {
                        _currentWeight = num.tryParse(value);
                      }
                    },
                  ),
                  TextFormField(
                    initialValue: userInfo?.height.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Height(cm): ',
                    ),
                    validator: (value) =>value!.isEmpty ? "enter your weight" : null,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        _height = null;
                      } else {
                        _height = num.tryParse(value);
                      }
                    },
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green
                      ),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          await DatabaseService(uid: user?.uid).updateUserData(
                              userInfo?.name,
                              _height ?? userInfo?.height,
                              _currentWeight ?? userInfo?.weight);
                          if(!mounted) return;
                          Navigator.pop(context);
                        }

                      }, child: const Text(
                    'Update',
                  ))
                ]
            ),
          );
        } else{
          return Container();
        }
  });
  }
}

