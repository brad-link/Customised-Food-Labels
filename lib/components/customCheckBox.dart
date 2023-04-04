import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({Key? key, required this.text, required this.padding, required this.checked, required this.onChanged}) : super(key: key);
  final String text;
  final EdgeInsets padding;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!checked);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(text)),
            Checkbox(
                value: checked,
                onChanged: (bool? newValue){
                  onChanged(newValue!);
                })
          ],
        ),
      ),
    );
  }
}
