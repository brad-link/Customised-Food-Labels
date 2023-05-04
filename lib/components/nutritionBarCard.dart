import 'package:cfl_app/main.dart';
import 'package:flutter/material.dart';

//used to display daily values for each macronutrient
class NutritionBarCard extends StatelessWidget {
  final String category;
  final int? limit;
  final num? value;
  const NutritionBarCard({Key? key, required this.category, required this.limit, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    num _value;
    String remaining;
    bool overTarget = false;
    num _limit = limit!;
    if(value! > _limit){
      //_value = (limit! - value!);
      _value = (value! - limit!);
      _limit = value!;
      remaining = '-${_value.toStringAsFixed(1)}';
      overTarget = true;
    } else {
      _value = limit! - value!;
      remaining = _value.toStringAsFixed(1);
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 150,
            child: Text(category,
            style: const TextStyle(
              color: myColor
            ),),),
            SizedBox( width: 50,
            child: Text('${value?.toStringAsFixed(1)}',
              textAlign: TextAlign.center,
                style: const TextStyle(
                color: myColor
            ))
              ,),
            SizedBox( width: 50,
              child: Text('${limit?.toStringAsFixed(1)}',
                style: const TextStyle(
                    color: myColor
                ),
                textAlign: TextAlign.center,),),
            SizedBox( width: 50,
              child: Text(remaining,
                style: const TextStyle(
                    color: myColor
                ),
                textAlign: TextAlign.center,),),
          ],
        ),
      SliderTheme(
        data: SliderThemeData(
          activeTrackColor: overTarget ? Colors.red : Colors.purple,
          thumbShape: SliderComponentShape.noThumb,
        ), child:
      Slider(
      min: 0.0,
      max: _limit.toDouble(),
      value: value!.toDouble(),
        onChanged: (value) {},
      ),
      ),
        ],
      ),
      ),
    );
  }
}
