import 'package:cfl_app/TrafficValues.dart';
import 'package:cfl_app/components/nutritionGoals.dart';
import 'package:cfl_app/macro_selection.dart';
import 'package:cfl_app/screens/home/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../appUser.dart';
import '../components/dietLog.dart';
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
  DateTime? dOB;
  String? name;
  int? height;
  num? currentWeight;
  String? gender;
  List<String> activityLevels = [
    'sedentary',
    'lightly active',
    'moderately active',
    'very active'
  ];
  List<String>  weightGoals= [
    'lose 1kg a week',
    'lose 0.75kg a week',
    'lose 0.5kg a week',
    'lose 0.25kg a week',
    'maintain weight',
    'gain 0.25kg a week',
    'gain 0.5kg a week',
    'gain 0.75kg a week',
    'gain 1kg a week',
  ];
  int? activeLevelSelected;
  int? weightGoalSelected;

  Future chooseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dOB ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dOB = picked;
      });
      //getAge(dOB);
    }
  }

  int getAge(DateTime? dOB) {
    if (dOB == null) {
      return 0;
    } else {
      DateTime now = DateTime.now();
      int age = (now.difference(dOB).inDays / 365.25).floor();
      return (age);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StreamBuilder<UserData?>(
          stream: DatabaseService(uid: user?.uid).userInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData? userInfo = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Personal details'),
                  centerTitle: false,
                ),
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name: ',
                              hintText: 'Please enter your full name'),
                          onChanged: (value) {
                            setState(() => name = value);
                          },
                          validator: (value) =>
                              value!.isEmpty ? "Enter Your Name" : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Current weight(kg): ',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "enter your weight" : null,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              currentWeight = null;
                            } else {
                              currentWeight = num.tryParse(value);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Height(cm): ',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "enter your weight" : null,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              height = null;
                            } else {
                              height = int.parse(value);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Column(
                          children: [
                            const Text('Gender: '),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text('Male'),
                                    value: 'Male',
                                    groupValue: gender,
                                    onChanged: (value) {
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
                                    onChanged: (value) {
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
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Text('Date of Birth: '),
                            IconButton(
                                onPressed: () => chooseDate(context),
                                icon: const Icon(Icons.calendar_today))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Text('Activity Level: '),
                            Expanded(child:
                            DropdownButtonFormField<int>(
                              value: activeLevelSelected,
                              onChanged: (int? newValue) {
                                setState(() {
                                  activeLevelSelected = newValue!;
                                  //checked = selectedPortion;
                                  //portion = double.parse(selectedPortion!);
                                });
                              },
                              items: activityLevels
                                  .map((option) => DropdownMenuItem<int>(
                                        value:
                                            activityLevels.indexOf(option) + 1,
                                        child: Text(option),
                                      ))
                                  .toList(),
                            ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Text('Activity Level: '),
                            Expanded(child:
                            DropdownButtonFormField<int>(
                              value: weightGoalSelected,
                              onChanged: (int? newValue) {
                                setState(() {
                                  weightGoalSelected = newValue!;
                                  //checked = selectedPortion;
                                  //portion = double.parse(selectedPortion!);
                                });
                              },
                              items: weightGoals
                                  .map((option) => DropdownMenuItem<int>(
                                value:
                                weightGoals.indexOf(option) + 1,
                                child: Text(option),
                              ))
                                  .toList(),
                            ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                print(gender);
                                if (_formKey.currentState!.validate()) {
                                  UserData update = UserData(
                                    name: name,
                                    height: height,
                                    weight: currentWeight,
                                    sex: gender,
                                    age: getAge(dOB),
                                    dOB: dOB,
                                    activityLevel: activeLevelSelected,
                                    weightGoal: weightGoalSelected
                                  );
                                  await DatabaseService(uid: user?.uid).updateUser(update);
                                  NutritionGoals goals = NutritionGoals();
                                  await DatabaseService(uid: user?.uid)
                                      .setNutritionGoals(goals);
                                  //await DatabaseService(uid: user?.uid).updateMTL(
                                  //3.0, 17.5, 1.5, 5.0, 5.0, 22.5, 0.3, 1.5);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MacroSelection(
                                              userData: update,
                                            )),
                                  );
                                }
                              },
                              child: const Text(
                                'Continue',
                              ))),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
