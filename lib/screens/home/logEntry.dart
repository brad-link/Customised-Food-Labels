import 'package:cfl_app/components/dietLog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogEntry extends StatelessWidget {

  final DietLog entry;
  const LogEntry({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEE, MMMM d, yyyy').format(entry.date),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Text(entry.calories as String),
          Text(entry.fat as String),
          Text(entry.carbohydrates as String),
          Text(entry.protein as String),
        ],
      ),
    );
  }
}
