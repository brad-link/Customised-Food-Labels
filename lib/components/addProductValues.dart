import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//custom textformfield for when adding new product values
// Text input for product name
// number input for updating values
class AddProductValues extends StatefulWidget {
  final bool text;
  late  String? value;
  final bool enabled;
  final String category;
  final Function(String) onchange;
  AddProductValues({Key? key, required this.text, required this.value, required this.category, required this.onchange, required this.enabled}) : super(key: key);

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
        style: const TextStyle(
          fontSize: 14,
        ),
        initialValue: widget.value, //!= null ? widget.value : null ,
        keyboardType: TextInputType.text,
        enabled: widget.enabled,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: category,
        ),
        onChanged: widget.onchange,
      );
    }
    else {
      return TextFormField(
          style: const TextStyle(
            fontSize: 14,
          ),
        initialValue: initialValue ,
          textInputAction: TextInputAction.next,
        enabled: widget.enabled,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: '$category per 100g',
        ),
        onChanged: widget.onchange
      );
    }

  }
}
