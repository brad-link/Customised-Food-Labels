import 'package:flutter/material.dart';

class TrafficCard extends StatelessWidget {
  final num? value1;
  final num? value2;

  TrafficCard({required this.value1, required this.value2});

  @override
  Widget build(BuildContext context) {
    num value3 = 100 - value2!;
    num totalValue = 100;
    num width1 = (value1! / totalValue) * 100;
    num width2 = (value2! / totalValue) * 100;
    num width3 = (value3 / totalValue) * 100;

    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: width1 * MediaQuery.of(context).size.width / 100,
            child: Container(
              color: Colors.green,
              child: Center(
                child: Text(
                  value1.toString(),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            left: width1 * MediaQuery.of(context).size.width / 100,
            top: 0,
            bottom: 0,
            width: width2 * MediaQuery.of(context).size.width / 100,
            child: Container(
              color: Colors.amber,
              child: Center(
                child: Text(
                  value2.toString(),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            left: (width1 + width2) * MediaQuery.of(context).size.width / 100,
            top: 0,
            bottom: 0,
            width: width3 * MediaQuery.of(context).size.width / 100,
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text(
                  value3.toString(),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}