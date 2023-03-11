import 'package:cfl_app/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../appUser.dart';
import '../../database.dart';
class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  //late UserData _userData;

  String? _name;
  num? _currentWeight;
  num? _height;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return StreamBuilder<UserData?>(
      stream: DatabaseService(uid: user?.uid).userInfo,
      builder: (context, snapshot){
        if(snapshot.hasData) {
          UserData? userInfo = snapshot.data;
          //_name = userInfo.name.toString()!;
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

