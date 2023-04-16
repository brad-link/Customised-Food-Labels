import 'package:cfl_app/TrafficValues.dart';
import 'package:cfl_app/components/nutritionGoals.dart';
import 'package:cfl_app/screens/home/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../appUser.dart';
import '../database.dart';
import '../userData.dart';
import 'home/home.dart';

class SetupForm extends StatefulWidget {
  const SetupForm({Key? key}) : super(key: key);

  @override
  State<SetupForm> createState() => _SetupFormState();
}

class _SetupFormState extends State<SetupForm> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  num? height;
  num? currentWeight;
  String? gender;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return StreamBuilder<UserData?>(
        stream: DatabaseService(uid: user?.uid).userInfo,
    builder: (context, snapshot){
          if(snapshot.hasData){
            UserData? userInfo = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Personal details'),
                centerTitle: false,
                backgroundColor: Colors.green,
              ),
            body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Name: ',
                        hintText: 'Please enter your full name'
                      ),
                      onChanged: (value){
                        setState(() => name = value);
                      },
                      validator: (value) => value!.isEmpty ? "Enter Your Name" : null,
                    ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Current weight(kg): ',
                        ),
                        validator: (value) =>value!.isEmpty ? "enter your weight" : null,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            currentWeight = null;
                          } else {
                            currentWeight = num.tryParse(value);
                          }
                        },
                      ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Height(cm): ',
                        ),
                        validator: (value) =>value!.isEmpty ? "enter your weight" : null,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            height = null;
                          } else {
                            height = num.tryParse(value);
                          }
                        },
                      ),
                    ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child:Column(
                children:[
                  const Text('Gender: '),
                Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (String? value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (String? value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
                ],
              ),
              ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                          ),
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              await DatabaseService(uid: user?.uid).updateUserData(
                                  name,
                                  height,
                                  currentWeight,);
                              NutritionGoals goals = NutritionGoals();
                              await DatabaseService(uid: user?.uid).setNutritionGoals(goals);
                              //await DatabaseService(uid: user?.uid).updateMTL(
                                  //3.0, 17.5, 1.5, 5.0, 5.0, 22.5, 0.3, 1.5);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    const HomeScreen()),
                              );
                            }

                          }, child: const Text(
                        'Continue',
                      ))
                    ),
                  ],
                ),
            ),
      );
          } else{
            return Container();
          }

    }
    );
  }
}
