import 'package:cfl_app/components/dietLog.dart';
import 'package:cfl_app/components/nutritionBarCard.dart';
import 'package:cfl_app/components/nutritionGoals.dart';
import 'package:cfl_app/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../appUser.dart';
import '../main.dart';



class NutritionWidget extends StatelessWidget {
  final DietLog? input;
  const NutritionWidget({Key? key, required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return StreamBuilder<NutritionGoals?>(
        stream: DatabaseService(uid: user?.uid).getGoals()
        ,builder: (context, snapshot) {
          if(snapshot.hasData) {
            NutritionGoals? goals = snapshot.data;
            List<int?> target = [goals?.calories, goals?.fat, goals?.saturates, goals?.carbohydrates,
              goals?.sugars, goals?.protein, goals?.salt];
            List<String> categories = [
              'calories',
              'fat',
              'saturates',
              'carbohydrates',
              'sugars',
              'protein',
              'salt',
              //'fibre'
            ];
            List<int?> values = [
              input?.calories,
              input?.fat,
              input?.saturates,
              input?.carbohydrates,
              input?.sugars,
              input?.protein,
              input?.salt,
              //input?.fibre
            ];
            final user = Provider.of<AppUser?>(context);
            return Container(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 150,
                      ),
                    SizedBox( width: 40,
                      child: Text('Total',
                          style: TextStyle(
                          color: myColor
                      ),
                        textAlign: TextAlign.center,),),
                    SizedBox( width: 40,
                      child: Text('Target',
                        style: TextStyle(
                            color: myColor
                        ),
                        textAlign: TextAlign.center,),),
                    SizedBox( width: 40,
                      child: Text('Left',
                        style: TextStyle(
                            color: myColor
                        ),
                        textAlign: TextAlign.center,),),
                  ],
                ),
                SizedBox(
                  height: 550,
                  child: ListView.builder(itemCount: 7,
                      itemBuilder: (context, index) {
                        return NutritionBarCard(category: categories[index],
                            limit: target[index],
                            value: values[index]);
                      }),
                ),
              ]
              ),
            );
          }
          else{
            return Container();
          }
    }
    );
  }
}

