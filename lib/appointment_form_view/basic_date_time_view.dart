import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

typedef DateTimeSaveCallback = void Function(DateTime dt);

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  
  final DateTimeSaveCallback onSaved;
  final DateTime startTime;

  BasicDateTimeField({Key key, this.onSaved, this.startTime});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // Text('Enter date and time for the appointment (${format.pattern})'),
      DateTimeField(
        initialValue: startTime,
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today),
          hintText: 'Enter date and time',
          labelText: 'Date and time *',
        ),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            onSaved(DateTimeField.combine(date, time));
            return DateTimeField.combine(date, time);
          } 
          else {
            onSaved(currentValue);
            return currentValue;
          }
        },
      ),
    ]);
  }
}
