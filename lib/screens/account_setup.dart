
import 'package:cfl_app/DataClasses/nutritionGoals.dart';
import 'package:cfl_app/screens/diet_settings.dart';
import 'package:cfl_app/screens/nutrition_goals_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../DataClasses/appUser.dart';
import '../database.dart';
import '../userData.dart';
import 'home/homeScreen.dart';


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
  bool? custom;
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
      initialDate: dOB ?? DateTime.now().subtract(const Duration(days: 3650)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        dOB = picked;
      });
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
      child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Personal details'),
                  centerTitle: false,
                ),
                body: SingleChildScrollView(
                  child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
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
                        padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.black.withOpacity(0.1))
                              ),child: Column(
                              children: [
                                const Text('Gender: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),),
                                Row(
                                  children:[
                                Expanded(
                                  child: RadioListTile(
                                    title: const Text('Male',
                                      style: TextStyle(fontSize: 12),),
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
                                  child: RadioListTile(
                                    title: const Text('Female',
                                      style: TextStyle(fontSize: 12),),
                                    value: 'Female',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ]),
                            ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black.withOpacity(0.1))
                        ),
                        child:Column(
                          children: [
                             const Text('Would you Like personalised nutrition goals or RDI: ',
                               textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    title: const Text('RDI',
                                    style: TextStyle(fontSize: 12),),
                                    value: false,
                                    groupValue: custom,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        custom = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    title: const Text('Personalised',
                                      style: TextStyle(fontSize: 12),),
                                    value: true,
                                    groupValue: custom,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        custom = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Date of Birth: '),
                            if(dOB != null)
                            TextButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white
                              ),
                                onPressed: () => chooseDate(context),
                                icon: const Icon(Icons.calendar_today),
                              label: Text(DateFormat('dd-MM-yyyy').format(dOB!),
                              style: const TextStyle(
                                color: Colors.black,
                              ),),),
                            if(dOB == null)
                              IconButton(
                                onPressed: () => chooseDate(context),
                                icon: const Icon(Icons.calendar_today),)
                          ],
                        ),),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  UserData update = UserData(
                                    name: name,
                                    custom: custom,
                                    sex: gender,
                                    age: getAge(dOB),
                                    dOB: dOB,
                                  );
                                  if(custom == false) {
                                    await DatabaseService(uid: user?.uid)
                                        .updateUser(update);
                                    NutritionGoals goals = NutritionGoals();
                                    await DatabaseService(uid: user?.uid)
                                        .setNutritionGoals(goals);
                                    if(!mounted) return;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                        const HomeScreen(),
                                        ),
                                    );
                                  } else if(custom == true) {
                                    await DatabaseService(uid: user?.uid)
                                        .updateUser(update);
                                    if(!mounted) return;
                                    Navigator.pushReplacement(
                                        context,
                                    MaterialPageRoute(builder: (context) =>  const NutritionGoalsSetup()));
                                  }
                                }
                              },
                              child: const Text(
                                'Continue',
                              ))),
                    ],
                  ),
                ),
                ),
              ),
            //} else {
              //return Container(
                //child: Text('ERROR'),
              //);
            //}
          //}),
    );
  }
}
