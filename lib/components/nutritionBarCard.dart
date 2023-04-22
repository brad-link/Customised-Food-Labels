import 'package:flutter/material.dart';

class NutritionBarCard extends StatelessWidget {
  final String category;
  final int? limit;
  final int? value;
  const NutritionBarCard({Key? key, required this.category, required this.limit, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _value;
    String remaining;
    bool overTarget = false;
    int _limit = limit!;
    if(value! > _limit){
      //_value = (limit! - value!);
      _value = (value! - limit!);
      _limit = value!;
      remaining = '-$_value';
      overTarget = true;
    } else {
      _value = limit! - value!;
      remaining = '$_value';
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
            child: Text(category),),
            SizedBox( width: 40,
            child: Text('$value',
              textAlign: TextAlign.center,),),
            SizedBox( width: 40,
              child: Text('$limit',
                textAlign: TextAlign.center,),),
            SizedBox( width: 40,
              child: Text(remaining,
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
