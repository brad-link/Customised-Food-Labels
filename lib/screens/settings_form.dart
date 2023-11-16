import 'package:cfl_app/DataClasses/nutritionGoals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DataClasses/appUser.dart';
import '../components/database.dart';
import '../DataClasses/userData.dart';
import 'settings/diet_settings.dart';

class SettingsForm extends StatefulWidget {
  final UserData? userData;
  const SettingsForm({Key? key, required this.userData}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
    final _formKey = GlobalKey<FormState>();
    bool? custom;


    @override
  void initState() {
    super.initState();
    custom = widget.userData?.custom;
  }
  void buttonPressed(){
      Navigator.pop(context);
  }
    @override
    Widget build(BuildContext context) {
      final user = Provider.of<AppUser?>(context);
      return StreamBuilder<UserData?>(
          stream: DatabaseService(uid: user?.uid).getUser(),
          builder: (context, snapshot){
            if(snapshot.hasData) {
              UserData? userInfo = snapshot.data;
              return Scaffold(
              appBar: AppBar(
                title: const Text('update details'),
                automaticallyImplyLeading: true,
                centerTitle: true,
              ),
                  body: Form(
                key: _formKey,
                child:SingleChildScrollView(child:Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Column(
                          children: [
                            const Text('Would you Like personalised nutrition goals or RDI: ',
                            style: TextStyle(fontSize: 14),),
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
                      if(custom == true)
                        DietSettings(button:() {}),
                      if(custom != true)
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                          ),
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              UserData update = UserData(
                                  name: userInfo?.name,
                                  custom: false,
                                  height: userInfo?.height,
                                  weight:  userInfo?.weight,
                                  sex: userInfo?.sex,
                                  age: userInfo?.age,
                                  dOB: userInfo?.dOB,
                                  activityLevel: userInfo?.activityLevel,
                                  weightGoal: userInfo?.weightGoal);
                              await DatabaseService(uid: user?.uid).updateUser(update);
                              NutritionGoals reference = NutritionGoals();
                              await DatabaseService(uid: user?.uid).setNutritionGoals(reference);
                              if(!mounted) return;
                              Navigator.pop(context);
                            }

                          }, child: const Text(
                        'Update',
                      ))
                    ]
                ),
                ),
                  ),
              );
            } else{
              return Container();
            }
          });
    }
  }

