import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NutritionBarCard extends StatelessWidget {
  final String category;
  final int limit;
  final int? value;
  const NutritionBarCard({Key? key, required this.category, required this.limit, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _value;
    if(value! > limit){
      _value = limit - value!;
    } else {
      _value = value!;
    }
    return Card(
      child: Padding(
        padding: EdgeInsets.all(2.0),
      child: Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('$category'),
            Text('$_value'),
            Text('$limit'),
          ],
        ),
      SliderTheme(
        data: SliderThemeData(
          activeTrackColor: Colors.green,
          thumbShape: SliderComponentShape.noThumb,
        ), child:
      Slider(
      min: 0.0,
      max: limit.toDouble(),
      value: _value.toDouble(),
        onChanged: (value) {},
      ),
      ),
        ],
      ),
      ),
    );
  }
}
