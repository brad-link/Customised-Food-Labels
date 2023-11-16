import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../DataClasses/appUser.dart';
import '../DataClasses/nutritionGoals.dart';
import '../components/database.dart';
import '../DataClasses/userData.dart';
import 'home/homeScreen.dart';

class NutritionGoalsSetup extends StatefulWidget {
  const NutritionGoalsSetup({Key? key}) : super(key: key);

  @override
  State<NutritionGoalsSetup> createState() => _NutritionGoalsSetupState();
}

class _NutritionGoalsSetupState extends State<NutritionGoalsSetup> {
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
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
          centerTitle: true,
        ),body: StreamBuilder<UserData?>(
        stream: DatabaseService(uid: user?.uid).getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userInfo = snapshot.data;
            //activeLevelSelected = userInfo?.activityLevel;
            //weightGoalSelected = userInfo?.weightGoal;
            return Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Padding(padding: EdgeInsets.all(8),
                child: TextFormField(
                  initialValue: "",
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Current weight(kg): ',
                    border: OutlineInputBorder(),
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
                ),),
                Padding(padding: EdgeInsets.all(8),
                    child: TextFormField(
                  initialValue: "",
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height(cm): ',
                    border: OutlineInputBorder(),
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
                ),),
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
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        UserData update = UserData(
                            name: userInfo?.name,
                            custom: userInfo?.custom,
                            height: height ?? userInfo?.height,
                            weight: currentWeight ?? userInfo?.weight,
                            sex: userInfo?.sex,
                            age: userInfo?.age,
                            dOB: userInfo?.dOB,
                            activityLevel: activeLevelSelected ?? userInfo?.activityLevel,
                            weightGoal: weightGoalSelected ?? userInfo?.weightGoal);
                        await DatabaseService(uid: user?.uid)
                            .updateUser(update);
                        NutritionGoals goals = NutritionGoals.setGoals(update);
                        await DatabaseService(uid: user?.uid)
                            .setNutritionGoals(goals);
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                          const HomeScreen(),
                          ),
                        );
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
        }));
  }
}
