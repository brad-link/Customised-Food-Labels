import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ValueCard extends StatelessWidget {
  final num? serving;
  final String? category;
  final num? size;
  final num? greenValue;
  final num? amberValue;
  final num? intake;
  final num? multiplier;
  const ValueCard({Key? key, this.category, this.size, this.greenValue, this.amberValue, this.intake, this.serving, this.multiplier}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    String? percOutput;
    num? portionSize;
    String portionRounded = '';
    if(size != null) {
      num percentage = ((size! / intake!) * serving!) * multiplier!;
      portionSize =((size!/100) * serving! * multiplier!);
      percOutput = percentage.toStringAsFixed(2);
      portionRounded = portionSize.toStringAsFixed(2);
    }




    Color getColour(num value){
      if(value == -1 || greenValue == null || amberValue == null){
        return Colors.white10;
      }else if(value <= greenValue!){
        return Colors.green.withOpacity(0.4);
      } else if(value <= amberValue!){
        return Colors.amber.withOpacity(0.4);
      } else{
        return Colors.red.withOpacity(0.4);
      }
    }

    return Column(
      children: [
        if(size != null)
      Card(
        color: getColour(size?? -1),
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
              child: Text('$category',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))
          ),
        ),
        Expanded(
          child: Container(
              child: Text('$portionRounded',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))
          ),
        ),
        Expanded(
          child: Container(
              child: Text('$percOutput%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))
          ),
        ),
      ],
    ),
    ),
        if(size == null)
          Card(
             child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$category information unavailable')
                ],
              ),
          )
    ]
    );
  }
}
