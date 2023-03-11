import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
/*
class DateForm extends StatelessWidget {
  static const _110Years = Duration(days: 365*110);
  final ValueChanged<DateTime> onChanged;
  final DateTime? currentValue;
  final FormFieldValidator<DateTime>? validator;
  final String label;
  const DateForm({Key? key,
  required this.onChanged,
  required this.currentValue,
  required this.validator,
  required this.label,
  }) : super(key: key);

  String get _label {
    if (currentValue == null) return label;

    return DateFormat.yMMMd().format(currentValue!);
  }



  @override
  Widget build(BuildContext context) {
    return FormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: currentValue,
      validator: validator,
      builder: (formState){
        late InputBorder shape;

        if (formState.hasError){
          shape = Theme.of(context).inputDecorationTheme.errorBorder!;
        } else {
          shape = Theme.of(context).inputDecorationTheme.enabledBorder!;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
            children: [
            _buildDateSelectListTile(shape, context, formState as FormField<DateTime>),
              if (currentValue != null) _buildFloatingLabel(context),
        ],
            ),
            if (formState.hasError) _buildErrorText(formState, context),

          ],
        );
      },
    );
  }
}

Widget _buildErrorText(
FormFieldState<DateTime> formState, BuildContext context){
  return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
    child: Text(
      formState.errorText!,
      style: Theme.of(context).inputDecorationTheme.errorStyle,
    ),
  );
}

Widget _buildDateSelectListTile(
  InputBorder shape,
  BuildContext context,
  FormField<DateTime> formState,
    Function(DateTime) onChanged,
){
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
  child: ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
      shape: shape,
      trailing: Icon(
        Icons.date_range,
        color: Colors.green,
      ),
    title: Text(_label),
    onTap: () async{
      final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(DateForm._110Years),
          lastDate: DateTime.now(),
      );
      if (date != null){
        formState.didChange(date);
        onChanged(date);
      }
    },
  ),
  );
}

Widget _buildFloatingLabel(BuildContext context){
  return Positioned(
    left: 12.0,
      top: -2.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          label,
          style: Theme.of(context).inputDecorationTheme.helperStyle,
        )
      )

  );


}*/

