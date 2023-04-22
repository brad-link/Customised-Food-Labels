import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductValues extends StatefulWidget {
  final bool isFilled;
  final bool text;
  late  String? value;
  final String category;
  final Function(String) onchange;
  AddProductValues({Key? key, required this.text, required this.value, required this.category, required this.onchange, required this.isFilled}) : super(key: key);

  @override
  State<AddProductValues> createState() => _AddProductValuesState();
}

class _AddProductValuesState extends State<AddProductValues> {
  @override
  Widget build(BuildContext context) {
    String category = widget.category;
    String? initialValue = widget.value;
    if(initialValue == 'null'){
      initialValue = null;
    }
    if(widget.text == true) {
      return TextFormField(
        //enabled: widget.isFilled,
        initialValue: widget.value, //!= null ? widget.value : null ,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: '$category',
        ),
        onChanged: widget.onchange,
      );
    }
    else {
      return TextFormField(
        //enabled: widget.isFilled,
        initialValue: initialValue ,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          hintText: '$category per 100g',
        ),
        onChanged: widget.onchange
      );
    }

  }
}
