import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class valueCard extends StatelessWidget {
  final String? category;
  final num? size;
  final num? greenValue;
  final num? amberValue;
  final num? intake;
  const valueCard({Key? key, this.category, this.size, this.greenValue, this.amberValue, this.intake}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Color getColour(num value){
      if(value <= greenValue!){
        return Colors.green.withOpacity(0.4);
      } else if(value <= amberValue!){
        return Colors.amber.withOpacity(0.4);
      } else{
        return Colors.red.withOpacity(0.4);
      }
    }
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      color: getColour(size!),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$category',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$size',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$intake%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
