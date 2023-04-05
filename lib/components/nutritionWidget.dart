import 'package:cfl_app/components/dietLog.dart';
import 'package:cfl_app/components/nutritionBarCard.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../appUser.dart';



class NutritionWidget extends StatelessWidget {
  final DietLog? input;
  const NutritionWidget({Key? key, required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> target = [3000, 90, 40, 300, 110, 100, 8, 50];
    List<String> categories = ['calories', 'fat', 'saturates', 'carbohydrates',
      'sugars', 'protein', 'salt', 'fibre'];
    List<int?> values = [input?.calories, input?.fat, input?.saturates, input?.carbohydrates,
    input?.sugars, input?.protein, input?.salt, input?.fibre];
    final user = Provider.of<AppUser?>(context);
    return Container(
        child:Column(  children: [
          SizedBox(
            height: 800,
            child: ListView.builder(itemCount: 8,
        itemBuilder: (context, index){
      return NutritionBarCard(category: categories[index], limit: target[index], value: values[index]);
   }),
          ),
      ]
        ),
    );
  }
}

