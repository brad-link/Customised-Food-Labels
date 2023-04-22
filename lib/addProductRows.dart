import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddProductRows extends StatelessWidget {
  final Widget category;
  final Widget input;

  const AddProductRows({Key? key, required this.category, required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1.0, color: Colors.black),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: category,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: input,
            ),
          ),
        ],
      ),
    );
  }
}
