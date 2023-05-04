import 'package:cfl_app/DataClasses/nutritionGoals.dart';
import 'package:cfl_app/main.dart';
import 'package:cfl_app/screens/home/homeScreen.dart';
import 'package:cfl_app/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import 'DataClasses/appUser.dart';
import 'database.dart';

class MacroSelection extends StatefulWidget {
  final UserData userData;
  const MacroSelection({Key? key, required this.userData}) : super(key: key);

  @override
  State<MacroSelection> createState() => _MacroSelectionState();
}

class _MacroSelectionState extends State<MacroSelection> {
  late int carbGoal;
  int? dailyCarbs;
  late int proteinGoal;
  int? dailyProtein;
  late int fatGoal;
  int? dailyFat;
  int? totalPercentage;
  int? calories;

  @override
  void initState() {
    super.initState();
    carbGoal = widget.userData.carbPercentage!;
    fatGoal = widget.userData.fatPercentage!;
    proteinGoal = widget.userData.proteinPercentage!;
    totalPercentage = fatGoal! + carbGoal! + proteinGoal!;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return Scaffold(
      body: StreamBuilder<NutritionGoals?>(
          stream: DatabaseService(uid: user?.uid).getGoals(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              NutritionGoals goals = snapshot.data!;
              calories = snapshot.data!.calories;
              dailyCarbs = snapshot.data!.carbohydrates;
              dailyProtein = snapshot.data!.protein;
              dailyFat = snapshot.data!.fat;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: Text(
                            'Daily\nCarbohydrate\nintake: \n${(calories! * (carbGoal / 100)) ~/ 4}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: Text(
                            'Daily\nProtein\nintake: \n${((calories! * (proteinGoal / 100)) ~/ 4)}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: Text(
                            'Daily\nFat\nintake: \n${((calories! * (fatGoal / 100)) ~/ 9)}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: WheelChooser.integer(
                            initValue: carbGoal,
                            minValue: 45,
                            maxValue: 65,
                            step: 5,
                            onValueChanged: (val) {
                              setState(() {
                                carbGoal = val;
                                dailyCarbs =
                                    (((calories! * carbGoal) / 100) * 4)
                                        .toInt();
                                totalPercentage =
                                    fatGoal! + carbGoal! + proteinGoal!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: WheelChooser.integer(
                            initValue: proteinGoal,
                            minValue: 10,
                            maxValue: 35,
                            step: 5,
                            onValueChanged: (val) {
                              setState(() {
                                proteinGoal = val;
                                dailyProtein =
                                    (((calories! * val) / 100) * 4).toInt();
                                totalPercentage =
                                    fatGoal! + carbGoal! + proteinGoal!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: WheelChooser.integer(
                            initValue: fatGoal,
                            minValue: 20,
                            maxValue: 35,
                            step: 5,
                            onValueChanged: (val) {
                              setState(() {
                                fatGoal = val;
                                dailyFat =
                                    (((calories! * val) / 100) * 9).toInt();
                                totalPercentage =
                                    fatGoal! + carbGoal! + proteinGoal!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Values must add up to 100: $totalPercentage'),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor.withOpacity(0.15),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text('cancel')),
                        ElevatedButton(
                            onPressed: totalPercentage == 100
                                ? () async {
                                    UserData update = UserData(
                                        name: widget.userData.name,
                                        custom: widget.userData.custom,
                                        height: widget.userData.height,
                                        weight: widget.userData.weight,
                                        age: widget.userData.age,
                                        sex: widget.userData.sex,
                                        dOB: widget.userData.dOB,
                                        activityLevel:
                                            widget.userData.activityLevel,
                                        carbPercentage: carbGoal,
                                        proteinPercentage: proteinGoal,
                                        fatPercentage: fatGoal,
                                        weightGoal: widget.userData.weightGoal);
                                    print(update.height);
                                    print(update.weight);
                                    print(update.age);
                                    await DatabaseService(uid: user?.uid)
                                        .updateUser(update);
                                    NutritionGoals goals =
                                        NutritionGoals.setGoals(update);
                                    await DatabaseService(uid: user?.uid)
                                        .setNutritionGoals(goals);
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: const Text('Update')),
                      ]),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
