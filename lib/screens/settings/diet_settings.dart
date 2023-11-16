import 'package:cfl_app/screens/settings/macro_selection.dart';
import 'package:cfl_app/DataClasses/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../DataClasses/appUser.dart';
import '../../DataClasses/nutritionGoals.dart';
import '../../components/database.dart';
import '../../main.dart';

class DietSettings extends StatefulWidget {
  final VoidCallback button;
  const DietSettings({
    Key? key, required this.button,
  }) : super(key: key);

  @override
  State<DietSettings> createState() => _DietSettingsState();
}

class _DietSettingsState extends State<DietSettings> {
  final _formKey = GlobalKey<FormState>();
  DateTime? dOB;
  //String? name;
  int? height;
  num? currentWeight;
  //String? gender;
  //bool custom = false;
  List<String> activityLevels = [
    'sedentary',
    'lightly active',
    'moderately active',
    'very active'
  ];
  List<String> weightGoals = [
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showMacroSettings(UserData userData) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.all(5),
              child: MacroSelection(userData: userData),
            );
          });
    }

    final user = Provider.of<AppUser?>(context);
    return StreamBuilder<UserData?>(
        stream: DatabaseService(uid: user?.uid).getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userInfo = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(children: <Widget>[
                const Text(
                  'Update Account details',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextFormField(
                  initialValue: userInfo?.weight.toString() == 'null' ? '': userInfo?.weight.toString(),
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
                TextFormField(
                  initialValue: userInfo?.height.toString() == 'null' ? '': userInfo?.height.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height(cm): ',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "enter your weight" : null,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      height = userInfo?.height;
                    } else {
                      height = int.parse(value);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Text('Activity Level: '),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: activeLevelSelected ?? userInfo?.activityLevel ,
                          onChanged: (int? newValue) {
                            setState(() {
                              activeLevelSelected = newValue!;
                            });
                          },
                          items: activityLevels
                              .map((option) => DropdownMenuItem<int>(
                                    value: activityLevels.indexOf(option) + 1,
                                    child: Text(option),
                                  ))
                              .toList(),
                          validator: (value) => value!.toString().isEmpty
                              ? "choose activity level"
                              : null
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Text('Weight Goal: '),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: weightGoalSelected ?? userInfo?.weightGoal ,
                          onChanged: (int? newValue) {
                            setState(() {
                              weightGoalSelected = newValue!;
                            });
                          },
                          items: weightGoals
                              .map((option) => DropdownMenuItem<int>(
                                    value: weightGoals.indexOf(option) + 1,
                                    child: Text(option),
                                  ))
                              .toList(),
                          validator: (value) => value!.toString().isEmpty
                              ? "choose weight goal"
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                if(userInfo != null)
                  TextButton(
                      onPressed: (){
                        showMacroSettings(userInfo);
                        },
                       child: Text('Update Macro Split: \n'
                      '${userInfo.carbPercentage} : ${userInfo.proteinPercentage} : ${userInfo.fatPercentage} \n'
                      'Current Split')),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: myColor),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        UserData update = UserData(
                            name: userInfo?.name,
                            custom: true,
                            height: height ?? userInfo?.height,
                            weight: currentWeight ?? userInfo?.weight,
                            sex: userInfo?.sex,
                            age: userInfo?.age,
                            dOB: userInfo?.dOB,
                            carbPercentage: userInfo?.carbPercentage,
                            proteinPercentage: userInfo?.proteinPercentage,
                            fatPercentage: userInfo?.fatPercentage,
                            activityLevel: activeLevelSelected ?? userInfo?.activityLevel,
                            weightGoal: weightGoalSelected ?? userInfo?.weightGoal);
                        await DatabaseService(uid: user?.uid)
                            .updateUser(update);
                        NutritionGoals goals = NutritionGoals.setGoals(update);
                        await DatabaseService(uid: user?.uid)
                            .setNutritionGoals(goals);
                        if (!mounted) return;
                        Navigator.pop(context);
                        widget.button;
                      }
                    },
                    child: const Text(
                      'Update',
                    ))
              ]),
            );
          } else {
            return Container();
          }
        });
  }
}
